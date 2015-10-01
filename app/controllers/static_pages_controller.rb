class StaticPagesController < ApplicationController
  def home
    redirect_to reviews_path if logged_in?
  end
end
