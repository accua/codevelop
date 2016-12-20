require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  user = params[:user]
  email = params[:email]
  password = params[:password]
end
