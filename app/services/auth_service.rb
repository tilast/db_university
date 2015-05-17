class AuthorizationError < StandardError; end

module AuthService
  class << self
    def authorize(login, password)
      generate_token(check_user(login, password))
    end

    def find_user_by_token(token)
      token = AccessTokenRepo.find_by_token(token)
      raise AuthorizationError unless token

      user  = UserRepo.find(token.user_id)
      raise AuthorizationError unless user

      user
    end

    private
    def check_user(login, password)
      user = UserRepo.find_by_login_and_pass(login, password)

      raise AuthorizationError unless user

      user
    end

    def generate_token(user)
      access_token = AccessToken.new(user_id: user.id, expires_at: Time.now + 7.day, token: SecureRandom.hex(20))
      AccessTokenRepo.save(access_token)
    end
  end
end