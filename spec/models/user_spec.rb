require 'rails_helper'

RSpec.describe User, type: :model do
  context "Querying an user" do
    let (:user) { FactoryGirl::create(:user) }
    it "can be done by email" do
      expect(User.find_by_email(user.email)).not_to be(nil)
    end
    it "can be done by phone" do
      expect(User.find_by_phone(user.phone)).not_to be(nil)
    end
    it "can be done by copynumber" do
      expect(User.find_by_copynumber(user.copynumber)).not_to be(nil)
    end
  end
end
