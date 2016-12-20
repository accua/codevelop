require 'bundler/setup'
require 'sinatra'
Bundler.require(:default)
enable :sessions
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


get('/') do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user]
  email = params[:email]
  password = params[:password]
  @user = User.create({user_name: user, email: email, password: password})
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
  email = params[:username]
  password = params[:password]
  @user = User.find_by(email: email, password: password)
  session[:id] = @user.id
  erb :home
end

get '/logout' do
  session.clear
  @logout = true
  erb :sign_in
end
