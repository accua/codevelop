require 'spec_helper'

describe Team do
  it { should have_many :team_messages}
  it { should have_many(:messages).through(:team_messages) }
  it { should have_many :team_posts}
  it { should have_many(:posts).through(:team_posts) }
  it { should have_and_belong_to_many :users }
end
