class Teammessage < ActiveRecord::Base
  belongs_to :teams
  belongs_to :message
end
