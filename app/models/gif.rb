class Gif
  include Virtus.model

  attribute :id,          Integer
  attribute :token,       String
  attribute :description, String
  attribute :created_at,  DateTime
  attribute :user_id,     Integer
end
