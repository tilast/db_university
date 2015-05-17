get '/' do
  session[:user] ||= "user#{rand}"
  
  response.set_cookie 'user', session[:user]

  erb :index, locals: { session: session[:user], cookie: request.cookies['user'] }
end

get '/signin' do
  VirtusRawPGRepo.adapter = $db
  user = VirtusRawPGRepo.find(User, 1)

  p user

  login, password = Base64.decode64(request.env['HTTP_AUTHORIZATION'][6..-1]).split ':'
  password = Digest::SHA1.hexdigest(password)

  result = $db.exec_prepared('check_user', [login, password])
  
  if result
    id         = result.first['id']
    expires_at = Time.now + 1.day
    token      = SecureRandom.hex 20
    $db.exec_prepared('create_access_token', [token, id, expires_at])
  else
    'error'
  end
end