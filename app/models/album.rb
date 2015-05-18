class Album
  include Virtus.model

  attribute :id,      Integer
  attribute :name,    String
  attribute :user_id, Integer
end
