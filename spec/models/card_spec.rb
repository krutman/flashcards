require 'rails_helper'

describe Card do
  
  let!(:user) { User.create(email: "misha@krutman.ru", password: "hellorex") }
  let!(:card) { user.cards.create(original_text: "кот", translated_text: "cat") }
  
  it "has default review_date on create" do
    expect(card.review_date).to eq Date.today + 3.days
  end
  
  context "when translated_text and original_text" do
    before { card.original_text = "cat" }
    
    context "has a strict equal" do
      before { card.translated_text = "cat" }
      it { should_not be_valid }
    end
    
    context "has a not strict equal" do
      before { card.translated_text = " CaT " }
      it { should_not be_valid }
    end
  end
  
  context "when check translation" do
    before do
      card.review_date = Date.today
      card.save!
    end
    
    context "correct and it has" do
      context "a strict equal" do
        it { expect(card.check_translation("кот")).to be true }
      end
    
      context "a not strict equal" do
        it { expect(card.check_translation(" КоТ ")).to be true }
      end
      
      context "update a review date" do
        before { card.check_translation("кот") }
        it { expect(card.reload.review_date).to eq Date.today + 3.days }
      end
    end
    
    context "not correct" do
      it "should be false" do
        expect(card.check_translation("Собака")).to be nil
      end
    end
  end
end
