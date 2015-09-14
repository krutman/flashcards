require 'rails_helper'

describe "Card review" do
  
  let!(:card) { create(:card, original_text: "кот", translated_text: "cat", review_date: Date.today - 3.days) }
  
  before(:each) { visit root_path }
  
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
end
