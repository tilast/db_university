require 'yaml'
require 'pg'

# init DB connection
db_settings = YAML::load(File.open(File.join(settings.root, 'config/database.yml')))

$conn = PG.connect( db_settings )