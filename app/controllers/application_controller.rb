class ApplicationController < ActionController::Base
  include Pagination
  protect_from_forgery with: :null_session

  def get_includes
    @includes ||= (params[:includes] || [])
  end

  def current_user
    if request.headers['Authorization'] && request.headers['Authorization'].match(/Bearer (.+)/)
      token = request.headers['Authorization'].match(/Bearer (.+)/)[1]
    end
    token ||= params[:access_token]
    @current_user ||= User.active.joins("LEFT JOIN api_keys AS a on a.user_id = users.id").where("a.key = ? AND a.expires_at > ?", SecurityHelper.sha_hash(token), Time.now).first if token
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

end
