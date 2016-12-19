class Language < ActiveRecord::Base
  has_many :users, through: :language_skills
end
