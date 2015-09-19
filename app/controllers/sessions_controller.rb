class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  
  def new
    @user = User.new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
      flash[:success] = 'Welcome, ' + @user.email
      redirect_back_or_to root_path
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
      params.require(:session).permit(:email, :password)
    end
end
