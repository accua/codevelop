class Post < ActiveRecord::Base
  has_many :comments
  has_many :team_posts
  has_many :teams, through: :team_posts
  belongs_to :user
end
