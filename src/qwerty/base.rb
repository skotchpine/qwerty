template :layout do
  File.read(File.join(File.dirname(File.dirname(__dir__)), 'views', 'layout.haml'))
end

get '/' do
  if session[:user_id]
    redirect '/app/home', 301
  else
    redirect '/auth/sign_in', 301
  end
end