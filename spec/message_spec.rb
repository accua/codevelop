require 'spec_helper'

describe Message do
  it { should have_many :team_messages}
  it { should have_many(:teams).through(:team_messages) }
  it { should have_and_belong_to_many :users }
end
