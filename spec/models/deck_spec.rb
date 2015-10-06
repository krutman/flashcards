require 'rails_helper'

describe Deck do
  
  let!(:user) { create(:user, email: "misha@krutman.ru", password: "hellorex", password_confirmation: "hellorex") }
  let!(:first_deck) { create(:deck, user: user, title: "first", current: "true") }
  let!(:second_deck) { create(:deck, user: user, title: "second", current: "false") }
  
  context "set correct current deck" do
    before { second_deck.update_attributes(current: true) }
    
    it { expect(first_deck.reload.current).to eq false }
    it { expect(second_deck.reload.current).to eq true }
  end
end
