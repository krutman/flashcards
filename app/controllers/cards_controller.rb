class CardsController < ApplicationController
    
  def index
    @cards = Card.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @card = Card.new
    @card.review_date ||= (Date.current + 3).strftime('%d-%m-%Y')
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
    @card = Card.find(params[:id])
    @card.review_date = @card.review_date.strftime('%d-%m-%Y')
  end
  
  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      flash[:success] = "Карточка обновлена"
      redirect_to cards_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    flash[:success] = "Карточка удалена"
    redirect_to cards_path
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
end
