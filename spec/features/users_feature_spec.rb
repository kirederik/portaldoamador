require "rails_helper"
require 'capybara/rspec'

RSpec.describe "Users", :type => :feature do

  # let(:user_attr) {FactoryGirl.attributes_for(:user)}
  let(:user) {FactoryGirl.create(:user)}

  before(:each) do
    user.save!
  end

  describe "userlist" do
    it "should see a user list" do
      login_as(user, :scope => :user)
      visit "/users.json"
      expect(page).to have_content user.email
    end
  end

  context "when in login page" do
    describe "the signin process" do
      it "signs me in" do
        visit '/login'
        within("#session") do
          fill_in 'user_email', :with => user.email
          fill_in 'user_password', :with => user.password
        end
        click_button 'Log in'
        expect(page).to have_content 'Success'
      end
    end
  end
end
