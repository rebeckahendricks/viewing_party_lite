class ApplicationController < ActionController::Base
  helper_method :user_id_in_session

  def user_id_in_session
    session[:user_id]
  end
end
