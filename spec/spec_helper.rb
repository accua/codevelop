ENV['RACK_ENV'] = 'test'
require('rspec')
require('pg')
require('sinatra/activerecord')
require('user')
require('group')
require('message')

RSpec.configure do |config|
  config.after(:each) do
    User.all.each(&:destroy)
    Group.all.each(&:destroy)
    Message.all.each(&:destroy)
  end
end
