class User < ActiveRecord::Base
  has_many :comments
  has_many :followers
  has_many :followings
  has_many :languages, through: :language_skills
  has_and_belongs_to_many :messages
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :teams
end
