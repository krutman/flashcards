class ReviewsController < ApplicationController
  before_action :require_login
  
  def new
    if current_user.current_deck.present?
      @card = current_user.current_deck.cards.random_for_review.first
    else
      @card = current_user.cards.random_for_review.first
    end
  end

  def create
    @card = current_user.cards.find(review_params[:card_id])
    if @card.check_translation(review_params[:original_text])
      flash[:success] = "Правильный ответ"
      redirect_to reviews_path
    else
      flash.now[:danger] = "Неправильный ответ"
      render 'new'
    end
  end
  
  private

    def review_params
      params.require(:review).permit(:card_id, :original_text)
    end
end
