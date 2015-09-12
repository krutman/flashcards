class ReviewsController < ApplicationController
  before_action :find_card, only: [:create]
  
  def new
    @card = Card.random_for_review.first
  end

  def create
    if @card.check_translation(review_params[:original_text])
      flash[:success] = "Правильный ответ"
      redirect_to root_path
    else
      flash.now[:danger] = "Неправильный ответ"
      render 'new'
    end
  end
  
  private

    def review_params
      params.require(:review).permit(:card_id, :original_text)
    end

    def find_card
      @card = Card.find(review_params[:card_id])
    end
end
