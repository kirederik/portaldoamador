require 'rails_helper'

RSpec.describe User, type: :model do
  context "creation" do
    let (:user_fields) {
      {
        fullname: "John Doe",
        email: "example@example.com",
        phone: "12341234",
        copynumber: "12341234",
        password: "12341234"
      }
    }

    context "when using already used fields" do
      before(:each) {
        user = User.new(user_fields)
        user.save
      }
      it "fails when email is in use" do
        user = User.new(user_fields)
        expect(user.valid?).to be_falsy
        expect(user.errors.messages[:email]).to include("já está em uso")
      end
    end

    describe "the field validation" do
      it "fails when email is invalid" do
        user_fields[:email] = "invalid"
        user = User.new(user_fields)
        expect(user.valid?).to be_falsy
        expect(user.errors.messages[:email]).to include("inválido")
      end
      context "for the password" do
        it "fails when it's not strong" do
          user_fields[:password] = "1111"
          user_fields[:password_confirmation] = "1111"
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:password]).to include("muito curta (mínimo 8 caracteres)")
        end
        it "fails when the confirmation doesn't match" do
          user_fields[:password] = "1234"
          user_fields[:password_confirmation] = "4321"
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:password_confirmation]).to include("não é igual a Senha")
        end
      end

      context "when has empty required field" do
        let(:required_error) { "não pode ficar em branco" }

        it "fails when fullname is not defined" do
          user_fields[:fullname] = ""
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:fullname]).to include(required_error)
        end

        it "fails when phone is not defined" do
          user_fields[:phone] = ""
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:phone]).to include(required_error)
        end

        it "fails when copynumber is not defined" do
          user_fields[:copynumber] = ""
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:copynumber]).to include(required_error)
        end

        it "fails when password is not defined" do
          user_fields[:password] = ""
          user_fields[:password_confirmation] = ""
          user = User.new(user_fields)
          expect(user.valid?).to be_falsy
          expect(user.errors.messages[:password]).to include(required_error)
        end
      end
    end
  end

  context "querying" do
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
