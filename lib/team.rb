class Team < ActiveRecord::Base
  has_many :team_messages
  has_many :messages, through: :team_messages
  has_many :team_posts
  has_many :posts, through: :team_posts
  has_and_belongs_to_many :users
end
