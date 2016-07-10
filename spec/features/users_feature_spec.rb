require "rails_helper"
require 'capybara/rspec'

RSpec.describe "User", :type => :feature do
  describe "/user" do
    context "when logged in as admin" do
      let(:user) { FactoryGirl.create(:user) }
      let(:admin) { FactoryGirl.create(:admin) }

      let(:name_field) { "Nome Completo" }
      let(:email_field) { "Email" }
      let(:phone_field) { "Telefone" }
      let(:copy_field) { "Exemplar" }
      let(:pass_field) { "Senha" }
      let(:conf_field) { "Confirmação de Senha" }

      before(:each) do
        login_as(admin)
      end

      context "and creating users" do
        before(:each) do
          visit root_path
          find(:css, "#users-handler").click
          click_link "Novo"
          expect(page).to have_content("Novo Usuário")
        end
        describe "with the correct fields value" do
          it "can create an user" do
            within("#new_user") do
              fill_in name_field,  :with => user.fullname
              fill_in email_field, :with => "unique" + user.email
              fill_in phone_field, :with => user.phone
              fill_in copy_field,  :with => user.copynumber
              fill_in pass_field,  :with => user.password
              fill_in conf_field,  :with => user.password
            end
            click_button 'Salvar'
            expect(page).to have_content 'Usuário criado com sucesso'
            expect(page).to have_content(user.fullname)
            expect(page).to have_content(user.email)
            expect(page).to have_content(user.phone)
            expect(page).to have_content(user.copynumber)
          end
        end

        describe "with incorrect fields value" do
          before(:each) do
            within("#new_user") do
              fill_in name_field,  :with => user.fullname
              fill_in email_field, :with => user.email
              fill_in phone_field, :with => user.phone
              fill_in copy_field,  :with => user.copynumber
              fill_in pass_field,  :with => user.password
              fill_in conf_field,  :with => user.password
            end
          end

          it "shows invalid email message" do
            within("#new_user") do
              fill_in email_field, :with => "invalid@email"
            end
            click_button "Salvar"
            expect(page).to have_content "Email inválido"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq("invalid@email")
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows passwords don't match" do
            within("#new_user") do
              fill_in conf_field, :with => user.password + "2"
            end
            click_button "Salvar"
            expect(page).to have_content "Confirmação de Senha não é igual a Senha"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows password is too short" do
            within("#new_user") do
              fill_in conf_field, :with => "123"
              fill_in pass_field, :with => "123"
            end
            click_button "Salvar"
            expect(page).to have_content "Senha muito curta (mínimo 8 caracteres)"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows password can't be blank" do
            within("#new_user") do
              fill_in conf_field, :with => ""
              fill_in pass_field, :with => ""
            end
            click_button "Salvar"
            expect(page).to have_content "Senha não pode ficar em branco"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows name can't be blank" do
            within("#new_user") do
              fill_in name_field, :with => ""
            end
            click_button "Salvar"
            expect(page).to have_content "Nome Completo não pode ficar em branco"
            expect(find_field(name_field).value).to eq("")
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows phone can't be blank" do
            within("#new_user") do
              fill_in phone_field, :with => ""
            end
            click_button "Salvar"
            expect(page).to have_content "Telefone não pode ficar em branco"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq("")
            expect(find_field(copy_field).value).to eq(user.copynumber)
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end

          it "shows copynumber can't be blank" do
            within("#new_user") do
              fill_in copy_field, :with => ""
            end
            click_button "Salvar"
            expect(page).to have_content "Exemplar não pode ficar em branco"
            expect(find_field(name_field).value).to eq(user.fullname)
            expect(find_field(email_field).value).to eq(user.email)
            expect(find_field(phone_field).value).to eq(user.phone)
            expect(find_field(copy_field).value).to eq("")
            expect(find_field(pass_field).value).to be_nil
            expect(find_field(conf_field).value).to be_nil
          end
        end

        describe "with fields already in use" do
          it "fails when email is in use" do
            within("#new_user") do
              fill_in name_field,  :with => user.fullname
              fill_in email_field, :with => user.email
              fill_in phone_field, :with => user.phone
              fill_in copy_field,  :with => user.copynumber
              fill_in pass_field,  :with => user.password
              fill_in conf_field,  :with => user.password
            end
            click_button 'Salvar'
            expect(page).to have_content 'Email já está em uso'
          end
        end
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
