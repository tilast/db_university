get '/' do
end

get '/signin.json' do
  login, password = Base64.decode64(request.env['HTTP_AUTHORIZATION'][6..-1]).split(':')
  password = Digest::SHA1.hexdigest(password.to_s)

  begin
    json token: AuthService.authorize(login, password).token
  rescue AuthorizationError => e
    status 403
    json error: e.message
  end
end

post '/signup.json' do
  begin
    json user: AuthService.signup(params[:login].to_s, params[:password].to_s)
  rescue SignupLoginLengthError, SignupPasswordLengthError, SignupLoginExistsError => e
    status 403
    json error: e.message
  end
end

get '/authorized_page.json' do
  begin
    user = AuthService.find_user_by_token request.env['HTTP_AUTHORIZATION'][6..-1]

    json user: UserSerializer.new(user)
  rescue AuthorizationError => e
    status 403
    json error: 'Access Forbidden'
  end
end