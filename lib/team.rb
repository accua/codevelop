class Team < ActiveRecord::Base
  has_many :team_messages
  has_many :messages, through: :team_messages
  has_many :posts_teams
  has_many :posts, through: :posts_teams
  has_and_belongs_to_many :users
end
