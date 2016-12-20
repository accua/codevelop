class Message < ActiveRecord::Base
  has_many :team_messages
  has_many :teams, through: :team_messages
  has_and_belongs_to_many :users
end
