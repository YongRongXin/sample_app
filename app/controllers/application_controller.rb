class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controllers.users.please_login"
    redirect_to login_url
  end
end
