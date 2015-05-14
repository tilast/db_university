# init DB connection
db_settings = YAML::load(File.open(File.join(settings.root, 'config/database.yml')))[Sinatra::Application.environment.to_s]

# ActiveRecord::Base.establish_connection(db_settings)
