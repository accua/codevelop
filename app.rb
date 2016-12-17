require("sinatra")
require("sinatra/reloader")
require('sinatra/activerecord')
also_reload("lib/**/*.rb")
require("pg")
require('./lib/user')
require('./lib/group')
require('./lib/message')

get('/') do
  erb(:index)
end
