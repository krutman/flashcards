require 'rails_helper'

RSpec.describe Card, type: :model do
  
  before { @card = Card.new(:original_text => "кот", :translated_text => "cat") }
  subject { @card }
  
  it { should respond_to(:original_text) }
  it { should respond_to(:translated_text) }
  it { should respond_to(:review_date) }
  it { should respond_to(:check_translation) }
  it { should be_valid }
  
  it "has none to begin with" do
    expect(Card.count).to eq 0
  end
  
  it "has one after adding one" do
    @card.save!
    expect(Card.count).to eq 1
  end
  
  it "not be valid when original_text is not present" do
    @card.original_text = nil
    should_not be_valid
  end
  
  it "not be valid when original_text is too long" do
    @card.original_text = "a" * 101
    should_not be_valid
  end
  
  it "not be valid when translated_text is not present" do
    @card.translated_text = nil
    should_not be_valid
  end
  
  it "not be valid when translated_text is too long" do
    @card.translated_text = "a" * 151
    should_not be_valid
  end
  
  it "has review_date" do
    @card.review_date = Date.today - 2.days
    expect(@card.review_date).to eq Date.today - 2.days
  end
  
  it "has default review_date on create" do
    @card.save!
    expect(@card.review_date).to eq Date.today + 3.days
  end
  
  describe "when translated_text and original_text" do
    before { @card.original_text = "cat" }
    
    describe "has a strict equal" do
      before { @card.translated_text = "cat" }
      it { should_not be_valid }
    end
    
    describe "has a not strict equal" do
      before { @card.translated_text = " CaT " }
      it { should_not be_valid }
    end
  end
  
  describe "scopes presence and" do
    before do
      @card1 = Card.create!(:original_text => "собака", :translated_text => "dog", :review_date => Date.today - 2.days)
      @card2 = Card.create!(:original_text => "птица", :translated_text => "bird", :review_date => Date.today + 2.days)
    end
  
    it "has default desc scope" do
      expect(Card.all.reload).to eq([@card2, @card1])
    end
  
    it "has for_review scope" do
      expect(Card.for_review.reload).to eq([@card1])
    end
    
    it "has random_for_review scope" do
      expect(Card.random_for_review.reload).to eq([@card1])
    end
  end
  
  describe "when check translation" do
    before do
      @card.review_date = Date.today
      @card.save!
    end
    
    describe "correct and it has" do
      describe "a strict equal" do
        it { expect(@card.check_translation("кот")).to be true }
      end
    
      describe "a not strict equal" do
        it { expect(@card.check_translation(" КоТ ")).to be true }
      end
      
      describe "update a review date" do
        before { @card.check_translation("кот") }
        it { expect(@card.review_date).to eq Date.today + 3.days }
      end
    end
    
    describe "not correct" do
      it "should be false" do
        expect(@card.check_translation("Собака")).to be nil
      end
    end
  end
end
