class CardsController < ApplicationController
  before_action :find_card, only: [:edit, :update, :destroy, :check_word]
    
  def index
    @cards = Card.by_creation_time.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @card = Card.new
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
  
  def home
    @card = Card.random_available_card
  end
  
  def check_word   
    if @card.correct_word?(params[:original_text])
      @card.update_review_date
      flash[:success] = "Правильный ответ"
      redirect_to root_path
    else
      flash.now[:danger] = "Неправильный ответ"
      render 'home'
    end
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
    
    def find_card
      @card = Card.find(params[:id])
    end
end
