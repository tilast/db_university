require 'bundler/setup'

$: << File.dirname(__FILE__)

require 'app/application'

run Sinatra::Application
