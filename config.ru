require 'bundler/setup'

$: << File.dirname(__FILE__)

require 'app/application'

map "/" do
  run PublicRoutes
end

map "/protected" do
  run ProtectedRoutes
end