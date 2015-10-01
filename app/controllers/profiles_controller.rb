class ProfilesController < ApplicationController
  before_action :require_login
  
  def show
  end
  
  def edit
  end
  
  def update
    if current_user.update_attributes(profile_params)
      flash[:success] = "Профиль обновлен"
      redirect_to profile_path
    else
      render 'edit'
    end
  end
  
  private
  
    def profile_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
end
