class Language < ActiveRecord::Base
  has_many :skills
  has_many :users, through: :skills

  def self.search(search)
    where("name like ?", "%#{query}%")
  end
end
