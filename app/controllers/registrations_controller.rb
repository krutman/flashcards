class RegistrationsController < ApplicationController
  before_action :restrict_registration
  
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if @user.save
      login(user_params[:email], user_params[:password])
      flash[:success] = 'Welcome, ' + @user.email
      redirect_to reviews_path
    else
      render 'new'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    def restrict_registration
      if logged_in?
        flash[:warning] = "You are already registered"
        redirect_to root_path
      end
    end
end
