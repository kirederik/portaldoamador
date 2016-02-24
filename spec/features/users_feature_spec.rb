require "rails_helper"
require 'capybara/rspec'

RSpec.describe "Users", :type => :feature do

  let(:user) {FactoryGirl.create(:user)}

  before(:each) do
    user.save!
  end

  describe "/login" do
    before(:each) do
      visit "/login"
    end
    context "when using the correct credentials" do
      it "can sign in" do
        within("#session") do
          fill_in 'user_email', :with => user.email
          fill_in 'user_password', :with => user.password
        end
        click_button 'Log in'
        expect(page).to have_content 'Success'
      end
    end

    context "when using invalid credentials" do
      it {
        within("#session") do
          fill_in 'user_email', :with => "foo@bar.com"
          fill_in 'user_password', :with => "notuser"
        end
        click_button 'Log in'
        expect(page).to have_content "Email ou senha inválidos."
      }
    end
  end
end
