# include WillPaginate::Sinatra::Helpers

enable :sessions
set :session_secret, "My session secret"

# get form for new user
get '/' do
  if logged_in?
    # redirect '/users/'+ current_user.id.to_s + '/questions'
    erb :"static/profile"
  else
    session[:user_id] = nil
    erb :"static/index"
  end
end

# create user
post '/user:id' do
  user = User.new(params[:user])
  if user.save
    flash[:msg] = "Account created successfully"
    session[:user_id] = User.find_by_email(user.email).id
    redirect '/profile'
  else
    flash[:error] = user.errors.full_messages.join('. ')
    redirect '/'
  end
end

# log the user in
post '/session:id' do
  user = User.find_by(email: params[:user][:email])
  if user != nil
    if !user.authenticate(params[:user][:password])
      flash[:error] = "Invalid password"
      redirect '/session/new'
    else
      # if log in successfully, store in session
      flash[:msg] = "Login Successfully"
      session[:user_id] = user.id
      if params[:id] == 0
        redirect '/users/' + user.id.to_s
      else
        redirect back
      end
    end
  else
    flash[:error] = "Invalid email"
    redirect '/'
  end
end

# particular user's profile from get '/users/:id'
get '/profile' do
  if logged_in?
    erb :"static/profile"
  else
    flash[:info] = "Please log in first."
    redirect '/session/new'
  end
end

# show particular user
get '/users/:id' do
  # some code here
  @user = User.find_by_id(params[:id])
  if @user != nil
    if logged_in? && current_user.id == params[:id].to_i
      redirect '/users/'+ current_user.id.to_s + '/questions'
    elsif logged_in?
      redirect '/users/' + current_user.id.to_s
    else
      redirect '/'
    end
  else
    redirect '/'
  end
end

# update edited user
patch '/users/:id' do
  @user = User.find(params[:id])
  if @user.update_attributes(params[:user])
    flash[:msg] = "Profile updated successfully"
    redirect '/profile'
  else
    flash[:error] = @user.errors.full_messages.join('. ')
    erb :'static/profile'
  end
end

# log the user out
delete '/session/:id' do
  # kill session
  session[:user_id] = nil
  flash[:msg] = "Logout successfully"
  redirect '/'
end
