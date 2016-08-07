class ApplicationController < ActionController::Base
  include Pagination
  include JwtHelper
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do
    render json: { message: 'You are not authorized to access this resource' }, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { message: 'resource not found' }, status: :not_found
  end

  def get_includes
    @includes ||= (params[:include] || [])
  end

  def current_user
    @current_user ||= User.find(jwt_session[:user_id]) if jwt_session[:user_id]
  end

  def current_or_blank_user
    current_user || User.new(id: -1)
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

end
