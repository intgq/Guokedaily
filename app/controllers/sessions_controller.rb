class SessionsController < ApplicationController
  include SessionsHelper

  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "登录失败，用户名/密码错误！"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to :login
  end
end
