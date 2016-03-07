module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)

    #redirect_to(session[:return_to] || default)
    if default.username.nil?
      redirect_to root_path
    else
      user_name = default.username
      redirect_to(session[:return_to] || room_rooms_path(user_name))
      session.delete(:return_to)
    end

  end

  def store_location
    session[:return_to] = request.url
  end

  def is_admin?

    if self.signed_in?
      current_user.admin?
    end

  end

end
