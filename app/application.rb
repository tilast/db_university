app_env = (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development' ).to_sym

# require these groups
require 'bundler/setup'
Bundler.require :default, app_env

require 'sinatra/main'
# override app environment
Sinatra::Application.environment = app_env
puts "Loaded #{Sinatra::Application.environment} environment"

set :root,      File.expand_path(File.join(File.dirname(__FILE__), '../'))
set :views,     File.join(settings.root, 'app', 'views')
set :base_uri,  '/'

$: << File.expand_path(File.join(settings.root, 'app/models'))
$: << File.expand_path(File.join(settings.root, '.'))

require 'config/config'

set :raise_errors, (ENV['RAISE_ERRORS'] == '1' || false)

Dir[File.join(settings.root, "app/models/*.rb")].sort.each do |file|
  autoload File.basename(file, '.rb').camelize.to_sym, file
end

%w(serializers/** controllers/** services).each do |folder|
  Dir[File.join(settings.root, "app/#{folder}/*.rb")].sort.each { |f| require f }
end

error 404 do
  '{"errors":[{"code":"record_not_found","message":"Couldn\'t find record"}]}'
end

enable :sessions

require 'tilt/erb'