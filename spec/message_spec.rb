require 'spec_helper'

describe Message do
  # it { should have_many(:teams).through(:messages_teams) }
  it { should have_and_belong_to_many :users }
end
