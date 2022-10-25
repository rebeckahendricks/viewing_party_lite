class ApplicationController < ActionController::Base
  def user_id_in_session
    session[:user_id]
  end
end
