require 'yaml'
require 'pg'

# init DB connection
db_settings = YAML::load(File.open(File.join(settings.root, 'config/database.yml')))
p db_settings
$db = PG.connect( db_settings )
$db.prepare('check_user', 'SELECT users.id FROM users WHERE login=$1 AND password=$2 LIMIT 1')
$db.prepare('create_access_token', 'INSERT INTO access_tokens(token, user_id, expires_at) VALUES($1, $2, $3)')