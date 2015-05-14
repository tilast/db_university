get '/' do
  session[:user] ||= "user#{rand}"
  
  response.set_cookie 'user', session[:user]

  erb :index, locals: { session: session[:user], cookie: request.cookies['user'] }
end