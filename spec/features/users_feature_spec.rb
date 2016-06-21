require "rails_helper"
require 'capybara/rspec'

RSpec.describe "User", :type => :feature do
  describe "/user" do
    context "when logged in as admin" do
      let(:user) { FactoryGirl.create(:user) }
      let(:admin) { FactoryGirl.create(:admin) }

      before(:each) do
        login_as(admin)
      end

      it "can create an user" do
	visit root_path
        find(:css, "#users-handler").click
        click_link "Novo"
        expect(page).to have_content("Novo Usuário")
	within("#new_user") do
          fill_in 'Nome Completo', :with => user.fullname
          fill_in 'Email', :with => "unique" + user.email
          fill_in 'Telefone', :with => user.phone
          fill_in 'Exemplar', :with => user.copynumber
          fill_in 'Senha', :with => user.password
          fill_in 'Confirme a senha', :with => user.password
        end
        click_button 'Salvar'
        expect(page).to have_content 'Usuário criado com sucesso'
        expect(page).to have_content(user.fullname)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.phone)
        expect(page).to have_content(user.copynumber)
      end

      it "can see user profile" do
        visit user_path(user)
        expect(page).to have_content("#{user.fullname}")
        expect(page).to have_content("#{user.phone}")
        expect(page).to have_content("#{user.email}")
        expect(page).to have_content("#{user.copynumber}")
      end
    end

    context "when logged in as user" do
      let (:user) { FactoryGirl.create(:user) }

      before(:each) do
	login_as(user)
      end

      it "can't create an user" do
	visit new_user_path
	expect(page.current_path).to eq root_path
      end
    end
  end
end
