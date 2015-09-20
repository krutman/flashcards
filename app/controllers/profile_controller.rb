class ProfileController < ApplicationController
  before_action :require_login
  before_action :correct_user
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(profile_params)
      flash[:success] = "Профиль обновлен"
      redirect_to profile_path(@user)
    else
      render 'edit'
    end
  end
  
  private
  
    def profile_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to reviews_path unless @user == current_user
    end
    
    def restrict_registration
      if logged_in?
        flash[:warning] = "You are already registered"
        redirect_to root_path
      end
    end
end
