class AccessTokenRepo
  extend Repo::Delegation

  def self.find_by_token(token)
    query("SELECT * FROM accesstokens WHERE token=|?| LIMIT 1", [token]).first
  end
end