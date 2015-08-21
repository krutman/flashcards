class CardsController < ApplicationController
  before_action :find_card, only: [:edit, :update, :destroy]
    
  def index
    @cards = Card.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @card = Card.new
    @card.review_date = format_date(@card.review_date)
  end
  
  def create
    @card = Card.new(card_params)
    if @card.save
      flash[:success] = "Карточка создана"
      redirect_to cards_path
    else
      render 'new'
    end
  end
  
  def edit
    @card.review_date = format_date(@card.review_date)
  end
  
  def update
    if @card.update_attributes(card_params)
      flash[:success] = "Карточка обновлена"
      redirect_to cards_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @card.destroy
    flash[:success] = "Карточка удалена"
    redirect_to cards_path
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
    
    def find_card
      @card = Card.find(params[:id])
    end
    
    def format_date(date)
      date.strftime('%d-%m-%Y')
    end
end
