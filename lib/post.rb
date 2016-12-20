class Post < ActiveRecord::Base
  has_many :comments
  has_many :team_posts
  has_many :teams, through: :team_posts
  has_and_belongs_to_many :users
end
