require "rails_helper"

RSpec.describe Users::RegistrationsController, :type => :controller do
  let (:admin) { FactoryGirl.create(:admin) }
  let (:user) { FactoryGirl.create(:user) }

  context "when not logged in" do
    before(:each) do
      fake_sign_in
    end
    it "cannot see the registration page" do
      get :index, {format: "json"}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/")
    end
  end
end
