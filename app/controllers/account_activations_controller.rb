class AccountActivationsController < ApplicationController
  include SessionsHelper
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_columns(activated: true, activated_at: Time.now)
      log_in user
      redirect_to user
    else
      redirect_to root_url
    end
  end
end
