class ReviewsController < ApplicationController
  before_action :find_card, only: [:create]
  
  def new
    @card = Card.availables_for_check.first
  end

  def create
    if @card.check_translation(params[:original_text])
      flash[:success] = "Правильный ответ"
      redirect_to root_path
    else
      flash.now[:danger] = "Неправильный ответ"
      render 'new'
    end
  end
end
