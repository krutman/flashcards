require 'rails_helper'

describe "Card review" do
  
  let!(:user) { create(:user, email: "misha@krutman.ru", password: "hellorex", password_confirmation: "hellorex") }
  let!(:deck) { create(:deck, user: user, title: "first", current: "false") }
  let!(:card) { create(:card, deck: deck, original_text: "кот", translated_text: "cat", review_date: Date.today - 3.days) }
  
  before(:each) { login("misha@krutman.ru", "hellorex") }
  
  it "correct answer for review" do
    fill_in "review_original_text", with: "Кот"
    click_button "Проверить слово"
    expect(page).to have_content "Правильный ответ"
  end
  
  it "incorrect answer for review" do
    fill_in "review_original_text", with: "собака"
    click_button "Проверить слово"
    expect(page).to have_content "Неправильный ответ"
  end
  
  context "with current deck" do
    let!(:current_deck) { create(:deck, user: user, title: "second", current: "true") }
    before { visit root_path }
    it { expect(page).to have_content "у вас нет доступных карточек для тренировки" }
  end
end
