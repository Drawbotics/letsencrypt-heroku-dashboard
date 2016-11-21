class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Assignable

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def auth_token
    current_user.auth_token
  end
  assign :auth_token

  def authorize
    redirect_to '/login' unless current_user
  end

end
