class AuthorizationError < StandardError; end

class SignupLoginLengthError < StandardError
  def message
    "Login is too short; minimum - 4 characters"
  end
end

class SignupLoginExistsError < StandardError
  def message
    "Login already exists"
  end
end

class SignupPasswordLengthError < StandardError
  def message
    "password is too short; minimum - 8 characters"
  end
end

module AuthService
  class << self
    def authorize(login, password)
      generate_token(check_user(login, password))
    end

    def find_user_by_token(token)
      token = AccessTokenRepo.find_by_token(token)
      raise AuthorizationError, "Can't find token" unless token

      user = UserRepo.find(token.user_id)
      raise AuthorizationError, "You didn't get this token" unless user

      user
    end

    def signup(login, password)
      raise SignupLoginLengthError    if login.length < 4
      raise SignupPasswordLengthError if password.length < 8
      raise SignupLoginExistsError    if UserRepo.query("SELECT * FROM users WHERE login = |?| LIMIT 1", [login]).length > 0

      UserRepo.save User.new(login: login, password: Digest::SHA1.hexdigest(password))
    end

    private
    def check_user(login, password)
      user = UserRepo.find_by_login_and_pass(login, password)

      raise AuthorizationError, "There is no user with such password" unless user

      user
    end

    def generate_token(user)
      access_token = AccessToken.new(user_id: user.id, expires_at: Time.now + 7.day, token: SecureRandom.hex(20))
      AccessTokenRepo.save(access_token)
    end
  end
end