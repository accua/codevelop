class Comment < ActiveRecord::Base
  belongs_to :posts
  belongs_to :users
end
