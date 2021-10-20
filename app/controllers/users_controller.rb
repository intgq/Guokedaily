class UsersController < ApplicationController
  include SessionsHelper
  before_action :request_logged, only: [:edit, :update, :index,
                                        :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def following
    @title = "全部关注"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "全部粉丝"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    user = User.find(params[:id])
    if user != current_user
      user.destroy
      flash[:success] = "删除成功"
    else
      flash[:error] = "不允许删除当前用户"
    end

    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = edit_account_activation_url(@user.activation_token,
                                                    email: @user.email).to_s

      UserMailer.account_activation(@user).deliver_now
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = "更新资料成功"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def request_logged
      unless logged_in?
        store_location
        flash[:danger] = "请登录后重试！"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      if @user != current_user
        redirect_to current_user
      end
    end

    def admin_user
      redirect_to(users_url) unless current_user.admin?
    end
end
