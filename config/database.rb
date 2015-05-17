require 'yaml'
require 'pg'

# init DB connection
db_settings = YAML::load(File.open(File.join(settings.root, 'config/database.yml')))
p db_settings
$db = PG.connect( db_settings )
Repo.adapter = $db