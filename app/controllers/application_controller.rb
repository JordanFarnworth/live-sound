class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def get_includes
    @includes ||= (params[:includes] || [])
  end

end
