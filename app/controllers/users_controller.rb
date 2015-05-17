get '/' do
  session[:user] ||= "user#{rand}"
  
  response.set_cookie 'user', session[:user]

  erb :index, locals: { session: session[:user], cookie: request.cookies['user'] }
end

get '/signin.json' do
  login, password = Base64.decode64(request.env['HTTP_AUTHORIZATION'][6..-1]).split(':')
  password = Digest::SHA1.hexdigest(password.to_s)

  begin
    json token: AuthService.authorize(login, password).token
  rescue AuthorizationError => e
    status 403
    json error: 'Access Forbidden'
  end
end

get '/authorized_page.json' do
  p request.env['HTTP_AUTHORIZATION'][6..-1]

  begin
    user = AuthService.find_user_by_token request.env['HTTP_AUTHORIZATION'][6..-1]

    json user: UserSerializer.new(user)
  rescue AuthorizationError => e
    status 403
    json error: 'Access Forbidden'
  end
end