class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      flash[:success] = t ".create.success_login_notify"
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t ".create.faild_login_notify"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".create.flash"
    redirect_to root_url
  end
end
