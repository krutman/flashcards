class DecksController < ApplicationController
  before_action :require_login
  before_action :find_deck, only: [:edit, :update, :destroy]

  def index
    @decks = current_user.decks.paginate(page: params[:page], per_page: 8)
  end
  
  def new
    @deck = current_user.decks.build
  end
  
  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      flash[:success] = "Колода создана"
      redirect_to decks_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @deck.update_attributes(deck_params)
      flash[:success] = "Колода обновлена"
      redirect_to decks_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @deck.destroy
    flash[:success] = "Колода удалена"
    redirect_to decks_path
  end
  
  private
  
    def deck_params
      params.require(:deck).permit(:title, :current)
    end
    
    def find_deck
      @deck = current_user.decks.find(params[:id])
    end
end
