app_env = (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development' ).to_sym

# require these groups
require 'bundler/setup'
Bundler.require :default, app_env

require 'tilt/erb'
require 'digest/sha1'
require 'base64'
require 'securerandom'
require 'active_support/all'
require 'json'

require 'sinatra/main'
require "sinatra/json"
# override app environment
Sinatra::Application.environment = app_env
puts "Loaded #{Sinatra::Application.environment} environment"

set :root,      File.expand_path(File.join(File.dirname(__FILE__), '../'))
set :views,     File.join(settings.root, 'app', 'views')
set :base_uri,  '/'

$: << File.expand_path(File.join(settings.root, 'app/models'))
$: << File.expand_path(File.join(settings.root, '.'))

set :raise_errors, (ENV['RAISE_ERRORS'] == '1' || false)
set :json_encoder, :to_json

Dir[File.join(settings.root, "app/models/*.rb")].sort.each do |file|
  autoload File.basename(file, '.rb').camelize.to_sym, file
end

%w(serializers/** controllers/** services repos).each do |folder|
  Dir[File.join(settings.root, "app/#{folder}/*.rb")].sort.each { |f| require f }
end

error 404 do
  '{"errors":[{"code":"record_not_found","message":"Couldn\'t find record"}]}'
end

before do
  content_type :json
end

require 'config/config'

class Rack::OAuth
  def initialize(app)
    @app = app
  end

  def call(env)    
    begin
      env[:user] = AuthService.find_user_by_token env['HTTP_AUTHORIZATION'][6..-1]
      
      status, headers, body = @app.call(env)
      
      [status, headers, body]
    rescue AuthorizationError => e
      headers = env.select {|k,v| k.start_with? 'HTTP_'}
      headers['Content-Type'] = 'application/json'
      
      [403, headers, [{error: 'Access Forbidden'}.to_json.to_s]]
    end
  end
end

class ProtectedRoutes < Sinatra::Base
  use Rack::OAuth

  def current_user
    request.env[:user]
  end
end

class PublicRoutes < Sinatra::Base
end
