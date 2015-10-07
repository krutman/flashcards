class CardsController < ApplicationController
  before_action :require_login
  before_action :find_deck, only: [:index, :new, :create]
  before_action :find_card, only: [:edit, :update, :destroy]

  def index
    @cards = @deck.cards.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @card = @deck.cards.build
  end
  
  def create
    @card = @deck.cards.build(card_params)
    if @card.save
      flash[:success] = "Карточка создана"
      redirect_to deck_cards_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @card.update_attributes(card_params)
      flash[:success] = "Карточка обновлена"
      redirect_to deck_cards_path(@card.deck_id)
    else
      render 'edit'
    end
  end
  
  def destroy
    @card.destroy
    flash[:success] = "Карточка удалена"
    redirect_to deck_cards_path(@card.deck_id)
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date, :cover)
    end
    
    def find_deck
      @deck = current_user.decks.find(params[:deck_id])
    end
    
    def find_card
      @card = Card.find(params[:id])
    end
end
