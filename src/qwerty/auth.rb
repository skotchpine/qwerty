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
  users = User.where(first_name: params[:first_name], last_name: params[:last_name])
  
  if users.any?
    redirect '/auth/sign_in?error=You already have an account. Sign in here.', 301
  else

    user = User.new \
      first_name: params[:first_name],
      last_name: params[:last_name],
      password: params[:password],
      password_confirmation: params[:password]

    if user.save
      redirect '/app/home', 301
    else
      haml :sign_up
    end
  end
end

post '/auth/sign_in' do
  user = User.where(first_name: params[:first_name], last_name: params[:last_name]).first

  if user
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:first_name] = user.first_name
      session[:last_name] = user.last_name

      redirect '/app/home', 301
    else
      redirect "/auth/sign_in?error=Access denied.", 301
    end
  else
    redirect "/auth/sign_in?error=That account doesn't exist.", 301
  end
end
  