class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:into] = t "controllers.password_resets.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "controllers.password_resets.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "controllers.password_resets.reset_success"
      redirect_to @user
    end
  end

  private
  def users_params
    params.require(:user).permit :password, :password_confirmation
  end
  
  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:warning] = "User not found"
    redirect root_path
  end

  def valid_user
    return if (@user.activated? && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end
end
