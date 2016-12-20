class Language < ActiveRecord::Base
  has_many :skills
  has_many :users, through: :skills
end
