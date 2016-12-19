class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :teams
  belongs_to :users
end
