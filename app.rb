require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'rest-client'
require 'json'
require 'bcrypt'
Dotenv.load
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
enable :sessions

if ENV['GH_BASIC_CLIENT_ID'] && ENV['GH_BASIC_SECRET_ID']
 CLIENT_ID        = ENV['GH_BASIC_CLIENT_ID']
 CLIENT_SECRET    = ENV['GH_BASIC_SECRET_ID']
end

use Rack::Session::Pool, :cookie_only => false

def authenticated?
  session[:access_token]
end

def authenticate!
  erb :github_sign_up, :locals => {:client_id => CLIENT_ID}
end

def login
  @user = User.find_by(email: params[:username])
  @user.nil? ? @user = User.find_by(user_name: params[:username]) : false
  if @user.nil?
    session[:error] = "Looks like no one exists with that username/password"
    redirect to '/sign_in'
  elsif @user.password == params[:password]
    session[:id] = @user.id
  else
    session[:error] = "Incorrect password. Try again my friend"
    redirect to '/sign_in'
  end
end

get '/' do
  erb :index
end

get '/sign_up' do
  @errors = session[:error]
  session[:error] = nil
  erb :sign_up
end

post '/sign_up' do
  user = params[:user_name]
  email = params[:email]
  if User.exists?(user_name: user)
    session[:error] = "That username is already taken"
    redirect '/sign_up'
  elsif User.exists?(email: email)
    session[:error] = "That email is already taken"
    redirect '/sign_up'
  else
    @user = User.new({user_name: user, email: email})
    @user.password = params[:password1]
    if @user.save!
    session[:id] = @user.id
    redirect to '/users/home'
    else
      session[:error] = "There was a problem saving your profile"
      redirect '/sign_up'
    end
  end
end

get '/users/home' do
  @user = User.find(session[:id])
  erb :home
end

get '/sign_in' do
  @errors = session[:error]
  session[:error] = nil
  erb :sign_in
end

post '/sign_in' do
  login
  erb :home
end

get '/logout' do
  session.clear
  redirect 'sign_in'
end

get '/github_sign_up' do
  erb :github_sign_up
end

get '/github' do
  if !authenticated?
    authenticate!
  else
    access_token = session[:access_token]
    scopes = []

    begin
      auth_result = RestClient.get('https://api.github.com/user',
                                   {:params => {:access_token => access_token},
                                    :accept => :json})
    rescue => e
      # request didn't succeed because the token was revoked so we
      # invalidate the token stored in the session and render the
      # index page so that the user can start the OAuth flow again

      session[:access_token] = nil
      binding.pry
      return authenticate!
    end

    @auth_result = JSON.parse(auth_result)
    @auth_result['private_emails'] =
        JSON.parse(RestClient.get('https://api.github.com/user/emails',
                       {:params => {:access_token => access_token},
                        :accept => :json}))


    session[:user] = @auth_result['login']
    erb :github_sign_up, :locals => {:client_id => CLIENT_ID}
  end
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']

  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => CLIENT_ID,
                           :client_secret => CLIENT_SECRET,
                           :code => session_code},
                           :accept => :json)

  session[:access_token] = JSON.parse(result)['access_token']
  redirect '/github'
end
