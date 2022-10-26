class ApplicationController < ActionController::Base
  helper_method :user_id_in_session, :current_user

  def user_id_in_session
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find(user_id_in_session) if session[:user_id]
  end
end
