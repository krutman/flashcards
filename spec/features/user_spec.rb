require 'rails_helper'

describe "User" do
  
  let!(:user) { create(:user, email: "misha@krutman.ru", password: "hellorex", password_confirmation: "hellorex") }
  let!(:other_user) { create(:user, email: "cat@cat.ru", password: "1234567", password_confirmation: "1234567") }
  
  context "sign up" do
    before do
      visit signup_path
      fill_in "user_email", with: "rex@rex.ru"
      fill_in "user_password", with: "hellorex"
      fill_in "user_password_confirmation", with: "hellorex"
      click_button "Sign up"
    end
    it { expect(page).to have_content "Welcome, rex@rex.ru" }
    it { expect(page).to have_content "Your account is not activated. Please check your email" }
    it { expect(last_email).to have_content "Welcome, rex@rex.ru" }
  end
  
  context "success activate user" do
    before { visit activate_registration_url(user.activation_token) }
    it { expect(page).to have_content "User was successfully activated" }
    it { expect(page).not_to have_content "Your account is not activated. Please check your email" }
    it { expect(last_email).to have_content "Congratulations, misha@krutman.ru" }
  end
  
  context "not success activate user" do
    before { visit activate_registration_url(user.activation_token + 'random_string') }
    it { expect(page).to have_content "Cannot activate this user" }
    it { expect(last_email).not_to have_content eq "Congratulations, misha@krutman.ru" }
  end
  
  context "reset password" do
    
    context "success send email" do
      before do
        visit login_path
        click_link "Forgot your password?"
        fill_in "reset_password_email", with: "misha@krutman.ru"
        click_button "Send reset instructions"
      end
      it { expect(page).to have_content "Instructions have been sent to your email" }
      it { expect(last_email).to have_content user.reset_password_token }
    end
    
    context "not success send email" do
      
      before do
        visit login_path
        click_link "Forgot your password?"
        fill_in "reset_password_email", with: "random@email.ru"
        click_button "Send reset instructions"
      end
      it { expect(page).to have_content("Email invalid") }
      it { expect(last_email).not_to have_content "Hello, random@email.ru!" }
    end
  end
  
  context "login" do
    before { login("misha@krutman.ru", "hellorex") }
    it { expect(page).to have_content("Welcome, misha@krutman.ru") }
  end
  
  context "edit profile" do
    before do
      user.activate!
      login("misha@krutman.ru", "hellorex")
      visit edit_profile_path
    end
    
    context "with email" do
      before do
        fill_in "user_email", with: "barack@obama.com"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "Профиль обновлен" }
      it { expect(page).to have_content "Your account is not activated. Please check your email" }
      it { expect(last_email).to have_content "Welcome, barack@obama.com" }
    end
    
    context "with correct current password" do
      before do
        fill_in "user_current_password", with: "hellorex"
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "Профиль обновлен" }
      it { expect(page).not_to have_content "Your account is not activated. Please check your email" }
    end
    
    context "with incorrect current password" do
      before do
        fill_in "user_current_password", with: "random_password123"
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "is wrong" }
    end
    
    context "with email and incorrect current password" do
      before do
        fill_in "user_email", with: "barack@obama.com"
        fill_in "user_current_password", with: "random_password123"
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "is wrong" }
      it { expect(page).not_to have_content "Your account is not activated. Please check your email" }
    end
    
    context "with email, correct current password and short password" do
      before do
        fill_in "user_email", with: "barack@obama.com"
        fill_in "user_current_password", with: "hellorex"
        fill_in "user_password", with: "123"
        fill_in "user_password_confirmation", with: "123"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "is too short (minimum is 6 characters)" }
    end
    
    context "with new password, without current password" do
      before do
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
        click_button "Сохранить настройки"
      end
      it { expect(page).to have_content "is wrong" }
    end
  end
  
  context "cannot edit profile without login" do
    before { visit edit_profile_path(user) }
    it { expect(page).to have_content "Please login first" }
  end
  
  context "can see own cards" do
    let!(:card) { create(:card, user: user, original_text: "собака", translated_text: "dog") }
    before do
      login("misha@krutman.ru", "hellorex")
      visit cards_path
    end
    it { expect(page).to have_content "dog" }
  end
  
  context "cannot see the card of other user" do
    let!(:card) { create(:card, user: other_user, original_text: "кот", translated_text: "cat") }
    before do
      login("misha@krutman.ru", "hellorex")
      visit cards_path
    end
    it { expect(page).not_to have_content "cat" }
  end
  
  context "cannot see profile without login" do
    before { visit profile_path(user) }
    it { expect(page).to have_content "Please login first" }
  end
  
  context "cannot see the profile of other user" do
    before do
      login("misha@krutman.ru", "hellorex")
      visit profile_path(other_user)
    end
    it { expect(page).to have_content "misha@krutman.ru" }
  end
  
  context "redirect to reviews after login" do
    before { login("misha@krutman.ru", "hellorex") }
    it { expect(current_path).to eq reviews_path }
  end
end
