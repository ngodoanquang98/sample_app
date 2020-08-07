class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t ".new.user_not_found"
    redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".new.success_notify"
      redirect_to @user
    else
      flash[:danger] = t ".new.faild_notify"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
