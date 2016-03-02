require "rails_helper"

RSpec.describe UsersController, :type => :controller do
  let (:admin) { FactoryGirl.create(:admin) }
  let (:user) { FactoryGirl.create(:user) }

  context "when not logged in" do
    before(:each) do
      fake_sign_in
    end
    it "cannot see the user list" do
      get :index, {format: "json"}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to("/")
    end
  end
  fcontext "when logged as admin" do
    before(:each) do
      fake_sign_in(admin)
    end
    it "can see the user list" do
      get :index, {format: "json"}
      expect(assigns(:users)).to eq([admin])
    end
  end
end
