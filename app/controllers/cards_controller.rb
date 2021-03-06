class CardsController < ApplicationController
  before_action :require_login
  before_action :find_card, only: [:edit, :update, :destroy]

  def index
    @cards = current_user.cards.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @card = current_user.cards.build
  end
  
  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      flash[:success] = "Карточка создана"
      redirect_to cards_path
    else
      render 'new'
    end
  end
  
  def edit
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
      params.require(:card).permit(:original_text, :translated_text, :review_date, :cover)
    end
    
    def find_card
      @card = current_user.cards.find(params[:id])
    end
end
