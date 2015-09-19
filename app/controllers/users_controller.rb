class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :restrict_registration, only: [:new, :create]
  
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if @user.save
      login(user_params[:email], user_params[:password])
      flash[:success] = 'Welcome, ' + @user.email
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Профиль обновлен"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    def restrict_registration
      if logged_in?
        flash[:warning] = "You are already registered"
        redirect_to root_url
      end
    end
end