require 'rails_helper'

describe "Deck review" do
  let!(:user) { create(:user, email: "misha@krutman.ru", password: "hellorex", password_confirmation: "hellorex") }
  let!(:first_deck) { create(:deck, user: user, title: "first") }
  let!(:second_deck) { create(:deck, user: user, title: "second") }
  
  before { login("misha@krutman.ru", "hellorex") }
  
  context "set current deck" do
    before do
      visit edit_deck_path(first_deck)
      check "deck_current"
      click_button "Сохранить изменения"
    end
    it { expect(user.reload.current_deck).to eq first_deck }
  end
  
  context "reset current deck" do
    before do
      visit edit_deck_path(first_deck)
      uncheck "deck_current"
      click_button "Сохранить изменения"
    end
    it { expect(user.reload.current_deck).to eq nil }
  end
end
