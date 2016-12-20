require 'spec_helper'

describe Post do
  # it { should belong_to(:team).through(posts_teams) }
  it { should have_and_belong_to_many :users}
  it { should have_many :comments}
end
