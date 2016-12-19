class Team < ActiveRecord::Base
  has_and_belongs_to_many :messages, through: :team_messages
  has_many :posts
  has_and_belongs_to_many :users
end
