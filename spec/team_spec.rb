require 'spec_helper'

describe Team do
  # it { should have_many(:messages).through(:messages_teams) }
  # it { should have_many(:posts).through(:posts_teams) }
  it { should have_and_belong_to_many :users }
end
