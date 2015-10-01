class OauthsController < ApplicationController
  before_action :require_login, only: :destroy
  
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    begin
      if logged_in?
        if @user = add_provider_to_user(provider)
          flash[:success] = "#{provider.titleize} connected success"
        else
          flash[:warning] = "#{provider.titleize} connected fail"
        end
        redirect_to root_path
      else
        if login_from(provider)
          flash[:success] = "Logged in from #{provider.titleize}"
          redirect_to root_path
        else
          @user = create_and_validate_from(provider)
          if @user.errors.added?(:email, :taken)
            existing_user = User.find_by(email: @user.email)
            if existing_user.activation_state == "active"
              auto_login(existing_user)
              add_provider_to_user(provider)
              flash[:success] = "#{provider.titleize} linked to existing account"
            else
              flash[:warning] = "Email from #{provider.titleize} linked to not activated account"
            end
            redirect_to root_path
          else
            @user = create_from(provider)
            @user.activate!
            UserMailer.activation_success_email(@user).deliver_now
            reset_session
            auto_login(@user)
            flash[:success] = "User account created from #{provider.titleize}!"
            redirect_to root_path
          end
        end
      end
      rescue
        flash[:warning] = "Something goes wrong"
        redirect_to root_path
    end  
  end
  
  def destroy
    provider = params[:provider]
    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      if authentication.destroy
        flash[:success] = "You have successfully unlinked your #{provider.titleize} account."
      else
        flash[:warning] = "#{provider.titleize} cannot be removed."
      end
    else
      flash[:warning] = "You do not currently have a linked #{provider.titleize} account."
    end
    redirect_to root_path
  end

  private
  
    def auth_params
      params.permit(:code, :provider)
    end
end
