$logger.level = (Sinatra::Application.production? ? Logger::INFO : Logger::DEBUG)

require 'config/database'