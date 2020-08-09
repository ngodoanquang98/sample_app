class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(new create index)

  def index
    @users = User.page(params[:page]).per Settings.paginate.items_per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".new.success_notify"
      redirect_to @user
    else
      flash[:danger] = t ".new.faild_notify"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".edit.success_edit_user_notify"
      redirect_to @user
    else
      flash[:danger] = t ".edit.faild_edit_user_notify"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_user_success_notify"
      redirect_to users_url
    else
      flash.now[:danger] = t ".delete_user_faild_notify"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".log_in_suggest"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".can_not_find_user"
    redirect_to root_url
  end
end
