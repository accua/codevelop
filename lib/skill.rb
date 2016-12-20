class Skill < ActiveRecord::Base
  has_many :languages
  belongs_to :user
end
