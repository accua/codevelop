class TeamMessage < ActiveRecord::Base
  belongs_to :team
  belongs_to :message
end
