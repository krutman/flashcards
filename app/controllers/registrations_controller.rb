class RegistrationsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.activation_needed_email(@user).deliver_now
      login(user_params[:email], user_params[:password])
      flash[:success] = 'Welcome, ' + @user.email
      redirect_to reviews_path
    else
      render 'new'
    end
  end
  
  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      UserMailer.activation_success_email(@user).deliver_now
      flash[:success] = 'User was successfully activated.'
      if logged_in?
        redirect_to profile_path
      else
        redirect_to login_path
      end
    else
      flash[:warning] = 'Cannot activate this user.'
      redirect_to root_path
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    def redirect_if_logged_in
      if logged_in?
        flash[:warning] = "You are already registered"
        redirect_to root_path
      end
    end
end
