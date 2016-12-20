require 'spec_helper' do
  describe 'test' do
    it 'does stuff' do
      visit '/'
      fill_in('user', :with => 'matt')
      fill_in('email', :with => 'matt@gmail.com')
      fill_in('password', :with => 'password')
      binding.pry
    end
  end
end
