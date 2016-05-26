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
  context "when logged as admin" do
    before(:each) do
      fake_sign_in(admin)
    end
    it "can see the user list" do
      get :index, {format: "json"}
      expect(assigns(:users)).to eq([admin])
    end

    it "can create users" do
      get :new
      expect(response).to render_template(:new)

      post :create, :user => {
        fullname: "Test",
        password: "Test123",
        password_confirmation: "Test123",
        phone: "12341234",
        copynumber: "457389"
      }
      expect(response).to redirect_to(assigns(:user))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include("Usuário criado com sucesso")

    end
  end
end
