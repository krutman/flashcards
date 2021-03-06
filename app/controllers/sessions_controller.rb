class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
  end

  def create
    if @user = login(session_params[:email], session_params[:password], session_params[:remember_me])
      flash[:success] = 'Welcome, ' + @user.email
      redirect_back_or_to reviews_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
  
  private
  
    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
    
    def redirect_if_logged_in
      if logged_in?
        flash[:warning] = "You are already logged in"
        redirect_to root_path
      end
    end
end
