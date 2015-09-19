require 'rails_helper'

describe "User" do
  
  let!(:user) { create(:user) }
  before(:each) { login_user }
  
  context "Edit profile" do
    before do
      visit edit_user_path(user)
      fill_in "user_email", with: "barack@obama.com"
      click_button "Сохранить настройки"
    end
    it { expect(page).to have_content "Профиль обновлен" }
  end
end
