class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :team
  has_and_belongs_to_many :users
end
