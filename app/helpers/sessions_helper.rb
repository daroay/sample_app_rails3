module SessionsHelper

  def sign_in(user)
    session[:remember_token] = [user.id, user.salt]
    current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def sign_out
    current_user = nil
    session[:remember_token] = [nil, nil]
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    session[:remember_token] || [nil, nil]
  end

  def current_user?(user)
    user == current_user
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page"
  end
 
  def store_location
    session[:retur_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:retur_to] || default)
    clear_retur_to
  end

  def clear_retur_to
    session[:retur_to] = nil
  end

end
