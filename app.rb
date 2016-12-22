require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'rest-client'
require 'json'
require 'bcrypt'
require 'pry'
Dotenv.load
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
enable :sessions

if ENV['GH_BASIC_CLIENT_ID'] && ENV['GH_BASIC_SECRET_ID']
 CLIENT_ID        = ENV['GH_BASIC_CLIENT_ID']
 CLIENT_SECRET    = ENV['GH_BASIC_SECRET_ID']
end
use Rack::Session::Pool, :cookie_only => false

def logged_in?
  session[:id]
end

def authenticated?
  session[:access_token]
end

def authenticate!
  erb :sign_up, :locals => {:client_id => CLIENT_ID}
end

def current_user
  User.find(session[:id])
end

def repos(user)
  access_token = session[:access_token]
  all_repos = JSON.parse(RestClient.get('https://api.github.com/user/repos',
                            {:params => {:access_token => access_token},
                            :accept => :json}))
  6.times do |time|
    user.repos.create({name: all_repos[time]['name'], url: all_repos[time]['html_url'], language: all_repos[time]['language']})
  end
end

def get_posts
  user = current_user
  posts_list = []
  user.followings.each do |following|
    follow = User.find(following.following_id)
    follow.posts.each do |post|
      posts_list.push(post)
    end
  end
  user.posts.each do |post|
    posts_list.push(post)
  end
  posts_list
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

def get_icon
  Language.create({name: "Ruby", icon: "<i class='devicon-ruby-plain colored'></i>"})
  Language.create({name: "Javascript" icon: "<i class='devicon-javascript-plain colored'></i>"})
  Language.create({name: "C#" icon: "<i class='devicon-csharp-plain colored'></i>"})
  Language.create({name: "HTML" icon: "<i class='devicon-html5-plain colored'></i>"})
  Language.create({name: "Java" icon: "<i class='devicon-java-plain colored'></i>"})
  Language.create({name: "Rails" icon: "<i class='devicon-rails-plain colored'></i>"})
  Language.create({name: "Angular" icon: "<i class='devicon-angularjs-plain colored'></i>"})
  Language.create({name: "CSS" icon: "<i class='devicon-css3-plain colored'></i>"})
  Language.create({name: "NodeJs" icon: "<i class='devicon-nodejs-plain colored'></i>"})
  Language.create({name: "PHP" icon: "<i class='devicon-php-plain colored'></i>"})
  Language.create({name: "Android" icon: "<i class='devicon-android-plain colored'></i>"})
  Language.create({name: "C++" icon: "<i class='devicon-cplusplus-plain colored'></i>"})
end

get '/' do
  if logged_in?
    redirect '/home'
  end
  erb :index, :locals => {:client_id => CLIENT_ID}
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user_name]
  email = params[:email]
  profile_picture = params[:profile_picture]
  repos = params[:repos]
  if User.exists?(user_name: user)
    session[:error] = "That username is already taken"
    redirect '/github'
  elsif User.exists?(email: email)
    session[:error] = "That email is already taken"
    redirect '/github'
  else
    @user = User.new({user_name: user, email: email, profile_picture: profile_picture, online: true})
    @user.password = params[:password1]
    if @user.save!
    session[:id] = @user.id
      if authenticated?
        repos(@user)
      end
    redirect '/home'
    else
      session[:error] = "There was a problem saving your profile"
      redirect '/sign_up'
    end
  end
end

get '/home' do
  @user = current_user
  @users = User.all
  @posts = get_posts
  @online_users = []
  User.all.each do |user|
    user.online and user.id != @user.id ? @online_users.push(user) : false
  end
  erb :home
end

get '/sign_in' do
  erb :sign_in, :locals => {:errors => session[:error]}
end

patch '/sign_in' do
  login
  user = User.find(session[:id])
  user.update({online: true})
  redirect '/home'
end

get '/logout' do
  User.update(session[:id], {online: false})
  session.clear
  redirect '/sign_in'
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
      return authenticate!
    end

    @auth_result = JSON.parse(auth_result)
    @auth_result['private_emails'] =
        JSON.parse(RestClient.get('https://api.github.com/user/emails',
                       {:params => {:access_token => access_token},
                        :accept => :json}))


    session[:user] = @auth_result['login']
    @user_name = @auth_result['login']
    @email = @auth_result['private_emails'][0]['email']
    @profile_picture = @auth_result['avatar_url']

    erb :sign_up
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
  session[:recent]? @recent = session[:recent] : false
  erb :messages
end

get '/message/new' do
  @users = User.all
  erb :message_form
end

get '/message/:id/new' do
  erb :message_form, :locals => {:user_id => params[:id]}
end

post '/message' do
  @user = User.find(session[:id])
  receiver = User.find_by(email: params[:receiver_id])
  if receiver.nil?
    receiver = User.find_by(user_name: params[:receiver_id])
  end
  new_message = Message.create(content: params[:content], receiver_id: receiver.id.to_i, sender_id: @user.id.to_i)
  if @user.messages.push(new_message) && receiver.messages.push(new_message)
    session[:recent] = receiver.id
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

get '/teams/new' do
  erb :team_create
end

post '/teams/:id' do
  name = params[:team_name]
  logo = params[:logo_url]
  bio = params[:team_bio]
  Team.create({name: name, team_info: bio, logo: logo})
  redirect '/team/:id'
end

get '/search' do
  if params[:query]
    search = params[:query] + "%"
    @users = User.where('user_name LIKE ?', search)
    @teams = Team.where('name LIKE ?', search)
    @language = Language.where('name LIKE ?', search)
    erb :results
  end
end

get '/teams' do
  @teams = Team.all()
  @user = User.find(session[:id])
  erb :teams
end

get '/teams/:id' do
  @team = Team.find(3)
  erb :team
end

post '/post_content' do
  @user = User.find(session[:id])
  content = params[:content]
  new_post = Post.create(content: content)
  @user.posts.push(new_post)
  redirect '/home'
end

get '/users/:id' do
  @user = User.find(session[:id].to_i)
  @following = User.find(params[:id].to_i)
  @user.followings.create({following_id: @following.id.to_i})
  #
  # @user = Lanuage.all()

  erb :profile, :locals => {:client_id => CLIENT_ID}
  # redirect '/home'
end

get '/users/:id/edit' do
  Language.get_icon
  @languages = Language.all
  erb :profile_edit
end

patch '/users/:id' do
  user_name = params.fetch("user_name")
  email = params.fetch("email")
  work = params.fetch("work")
  bio = params.fetch("bio")
  picture = params.fetch("profile_picture")
  @user = User.find(session[:id])
  @user.languages.each do |language|
    language.destroy
  end
  params[:languages].each do |language|
    @user.language.push(Language.find(language))
  end
  erb :profile
end

# get '/teams/:id' do
#
# end
#
# patch 'teams/:id' do
#
# end
#
# delete 'teams/:id' do
#
# end
get '/clear' do
  session.clear
  redirect '/'
end

get '/repos' do
  access_token = session[:access_token]
  all_repos = JSON.parse(RestClient.get('https://api.github.com/user/repos',
                            {:params => {:access_token => access_token},
                            :accept => :json}))
  names = []
  all_repos.each do |repo|
    names.push(repo['name'])
  end
binding.pry
end
