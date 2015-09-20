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
  end
  
  context "login" do
    before { login("misha@krutman.ru", "hellorex") }
    it { expect(page).to have_content("Welcome, misha@krutman.ru") }
  end
  
  context "edit profile" do
    before do
      login("misha@krutman.ru", "hellorex")
      visit edit_profile_path(user)
      fill_in "user_email", with: "barack@obama.com"
      click_button "Сохранить настройки"
    end
    it { expect(page).to have_content "Профиль обновлен" }
  end
  
  context "cannot edit other user" do
    before do
      login("misha@krutman.ru", "hellorex")
      visit edit_profile_path(other_user)
    end
    it { expect(current_path).to eq reviews_path }
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
    it { expect(current_path).to eq reviews_path }
  end
  
  context "redirect to reviews after login" do
    before { login("misha@krutman.ru", "hellorex") }
    it { expect(current_path).to eq reviews_path }
  end
end
