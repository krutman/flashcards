class ResetPasswordsController < ApplicationController
  before_action :redirect_if_logged_in
  
  def new
  end
  
  def create
    if @user = User.find_by_email(reset_password_params[:email])
      @user.deliver_reset_password_instructions!
      flash[:success] = 'Instructions have been sent to your email.'
      redirect_to login_path
    else
      flash.now[:danger] = 'Email invalid'
      render 'new'
    end
  end
  
  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    not_authenticated if @user.blank?
  end
  
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    not_authenticated && return if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      flash[:success] = 'Password was successfully updated'
      redirect_to login_path
    else
      render "edit"
    end
  end
  
  private
  
    def reset_password_params
      params.require(:reset_password).permit(:email)
    end
    
    def redirect_if_logged_in
      if logged_in?
        flash[:warning] = "You are already logged in"
        redirect_to root_path
      end
    end
end
