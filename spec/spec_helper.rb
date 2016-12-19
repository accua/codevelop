ENV['RACK_ENV'] = 'test'

require("bundler/setup")
Bundler.require(:default, :test)
set(:root, Dir.pwd())

require('capybara/rspec')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
require('./app')
Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.after(:each) do
    User.all.each(&:destroy)
    Team.all.each(&:destroy)
    Message.all.each(&:destroy)
    Posts.all.each(&:destroy)
    Comments.all.each(&:destroy)
    Followers.all.each(&:destroy)
    Following.all.each(&:destroy)
    Language.all.each(&:destroy)
  end
end
