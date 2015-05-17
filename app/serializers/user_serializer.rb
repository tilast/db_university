class UserSerializer
  def initialize(user)
    @id = user.id
    @login = user.login
  end

  def to_hash
    { id: @id, login: @login }
  end
end
