class AccessToken
  include Virtus.model

  attribute :id,         Integer
  attribute :token,      String
  attribute :user_id,    Integer
  attribute :expires_at, DateTime
end