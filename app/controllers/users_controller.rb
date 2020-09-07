class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.select(:id, :name, :email)
                 .page(params[:page]).per Settings.per_page
  end

  def show
    @microposts = @user.microposts.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users.please_check_activate"
      redirect_to root_url
    else
      flash[:danger] = t "controllers.users.acc_reg_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users.update_success"
      redirect_to @user
    else
      flash.now[:danger] = t "controllers.users.update_fail"
      render :edit
    end
  end

  def destroy
    @user.delete
    flash[:success] = t "controllers.users.delete_success"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if current_user? @user
 
    redirect_to root_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to root_path
  end
end
