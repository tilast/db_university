class UserRepo
  extend Repo::Delegation

  def self.find_by_login_and_pass(login, password)
    query("SELECT users.id FROM users WHERE login=|?| AND password=|?| LIMIT 1", [login, password]).first 
  end
end