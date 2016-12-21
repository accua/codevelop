require 'bundler/setup'
require 'sinatra'
require 'bcrypt'
Bundler.require(:default)
enable :sessions
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

def login
  @user = User.find_by_email(params[:username])
  if @user.password == params[:password]
    session[:id] = @user.id
  else
    redirect_to '/sign_in'
  end
end

get '/' do
  erb :index
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user_name]
  email = params[:email]
  if User.exists?(email: email)
    @email_error = true
    erb :sign_up
  elsif params[:password1] != params[:password2]
    @password_error = true
    erb :sign_up
  else
    @user = User.new({user_name: user, email: email})
    @user.password = params[:password]
    @user.save!
    session[:id] = @user.id
    redirect to '/users/home'
  end
end

get '/users/home' do
  @user = User.find(session[:id])
  erb :home
end

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  login
  erb :home
end

get '/logout' do
  session.clear
  @logout = true
  erb :sign_in
end

get '/conversation/:id' do
  @user = User.find(params[:id])
  erb :conversation, :layout => (request.xhr? ? false : :layout)
end

get '/messages' do
  user = User.find(session[:id])
  @users = []
  user.messages.each do |message|
    if message.sender_id != user.id && !@users.include?(User.find(message.sender_id.to_i))
      @users.push(User.find(message.sender_id.to_i))
    elsif message.receiver_id != user.id && !@users.include?(User.find(message.receiver_id.to_i))
        @users.push(User.find(message.receiver_id.to_i))
    end
  end
  # binding.pry
  erb :messages
end

get '/message/new' do
  @users = User.all
  erb :message_form
end

post '/message' do
  @user = User.find(session[:id])
  receiver = User.find_by(email: params[:receiver_id])
  new_message = Message.create(content: params[:content], receiver_id: receiver.id.to_i, sender_id: @user.id.to_i)
  if @user.messages.push(new_message) && receiver.messages.push(new_message)
    session[:recent] = User.find_by(email: params[:receiver_id]).id.to_i
    redirect '/messages'
  else
  erb :message_form
  end
end

get '/recent_message' do
  @user = User.find(session[:recent])
  erb :recent_conversation, :layout => (request.xhr? ? false : :layout)
end

get '/method' do
  User.all.each(&:destroy)
  redirect '/messages'
end
