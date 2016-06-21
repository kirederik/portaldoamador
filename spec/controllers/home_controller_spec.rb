require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  context "when not logged in" do
    describe "when request index" do
      it "should see login page" do
        get :index
        expect(response).to redirect_to("/login")
      end
    end
  end
end
