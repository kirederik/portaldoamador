require "rails_helper"
require 'capybara/rspec'

RSpec.describe "Users", :type => :feature do
  describe "/user" do
    context "when logged in as admin" do
      it "can see user list" do
        login_as(:admin)
      end
    end
  end
end
