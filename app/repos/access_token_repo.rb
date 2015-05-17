class AccessTokenRepo
  extend Repo::Delegation

  def self.find_by_token(token)
    query("SELECT * FROM accesstokens WHERE token=|?| AND expires_at > |?|  LIMIT 1", [token, Time.now.to_s]).first
  end
end