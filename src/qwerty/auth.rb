before '/auth/*' do
  redirect "/app/home", 301 if session[:user_id]
end

get '/auth/sign_up' do
  if session[:user_id]
    redirect "/app/home?error=You're already signed in", 301
  else
    haml :sign_up
  end
end

get '/auth/sign_in' do
  if session[:user_id]
    redirect "/app/home?error=You're already signed in", 301
  else
    haml :sign_in
  end
end

post '/auth/sign_up' do
  users = User.where(username: params[:username])
  
  if users.any?
    redirect '/auth/sign_up?error=That username already exists', 301
  else

    user = User.new \
      username: params[:username],
      password: params[:password],
      password_confirmation: params[:password]

    if user.save
      session[:user_id] = user.id
      session[:username] = user.username

      redirect '/app/home', 301
    else
      haml :sign_up
    end
  end
end

post '/auth/sign_in' do
  user = User.where(username: params[:username]).first

  if user
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:username] = user.username

      redirect '/app/home', 301
    else
      redirect "/auth/sign_in?error=Incorrect password.", 301
    end
  else
    redirect "/auth/sign_in?error=That username doesn't exist.", 301
  end
end
  