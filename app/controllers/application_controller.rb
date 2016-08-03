class ApplicationController < ActionController::Base
  include Pagination
  protect_from_forgery with: :exception

  def get_includes
    @includes ||= (params[:includes] || [])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

end
