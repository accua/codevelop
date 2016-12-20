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

get('/') do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user]
  email = params[:email]
  password = params[:password]
  @user = User.new({user_name: user, email: email})
  @user.password = password
  @user.save!
  binding.pry
  session[:id] = @user.id
  redirect to '/users/home'
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
