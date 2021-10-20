class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    def request_logged
        unless logged_in?
        store_location
        flash[:danger] = "请登录后重试！"
        redirect_to login_url
        end
    end
end
