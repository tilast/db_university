class User
  include Virtus.model

  attribute :id,       Integer
  attribute :login,    String
  attribute :password, String
end