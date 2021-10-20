module SessionsHelper
    # 存储转向地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 转向登录前页面
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end

  # 使用持久会话记录用户数据
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 返回当前系统登录用户
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 传入用户与当前用户是否为同一用户
  def current_user?(user)
    user == current_user
  end

  # 清除用户 cookies 及访问令牌
  # 不再使用持久会话记录用户数据
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 对当前用户做登出操作
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 对指定用户做登录操作
  def log_in(user)
    session[:user_id] = user.id
  end

  # 返回当前是否存在已登录用户
  def logged_in?
    !current_user.nil?
  end
end
