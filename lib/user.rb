class User < ActiveRecord::Base
  include BCrypt
  has_many :comments
  has_many :followers
  has_many :followings
  has_many :skills
  has_many :languages, through: :skills
  has_and_belongs_to_many :messages
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :teams

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.search(search)
    binding.pry
    where("user_name like ?", "%#{search}%")
  end
end
