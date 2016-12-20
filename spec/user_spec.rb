require 'spec_helper'

describe User do
  it { should have_many :comments }
  it { should have_many :followers }
  it { should have_many :followings }
  # it { should have_many(:languages).through(:skills) }
  it { should have_and_belong_to_many :messages }
  it { should have_and_belong_to_many :posts }
  it { should have_and_belong_to_many :teams }
end
