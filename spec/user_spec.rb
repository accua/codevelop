require 'spec_helper'

describe User do
  it { should have_many :comments }
  it { should have_many :followers }
  it { should have_many :followings }
  it { should have_many :skills }
  it { should have_many(:languages).through(:skills) }
  it { should have_and_belong_to_many :messages }
  it { should have_many :posts }
  it { should have_and_belong_to_many :teams }
end

describe 'User' do
  describe '#following' do
    it 'will return true if another user is following the session user' do
      new_user = User.create!({user_name: 'Ryan', email: 'a@b.com'})
      second_user = User.create!({user_name: 'Matt', email: 'a@c.com'})
      new_user.followings.create!({following_id: second_user.id})
      expect(new_user.following?(second_user.id)).to eq true
    end
  end
end
