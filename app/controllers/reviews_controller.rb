class ReviewsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: :create
  
  def new
    @card = current_user.cards.random_for_review.first if current_user
  end

  def create
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

    def correct_user
      @card = current_user.cards.find(review_params[:card_id])
      redirect_to root_path if @card.nil?
    end
end
