class SessionsController < ApplicationController
  include Api::V1::User
  include Api::V1::Entities
  include Api::V1::Enterprise
  include Api::V1::PrivateParty
  include Api::V1::Band

  def create
    auth = OpenStruct.new
    auth.provider = env["omniauth.auth"]["provider"]
    auth.uid = env["omniauth.auth"]["uid"]
    auth.name = env["omniauth.auth"]["info"]["name"]
    auth.image = env["omniauth.auth"]["info"]["image"]
    auth.oauth_token = env["omniauth.auth"]["credentials"]["token"]
    auth.oauth_expires_at = env["omniauth.auth"]["credentials"]["expires_at"]
    user = User.from_omniauth(auth)
    cookies[:access_token] = { value: create_jwt_session({ user_id: user.id }), expires: user.oauth_expires_at }
    redirect_to root_url
  end

  def logged_in_user
    if current_user
      render json: user_json(current_user, get_includes), status: :ok
    else
      render json: {error: 'not logged in'}, status: :unauthorized
    end
  end

  def current_entities
    render json: [], status: :ok unless logged_in?
    entities = current_user.entities
    render json: entities_json(current_user.entities, get_includes)
  end

  def logged_in?
    !!current_user
  end

  def destroy
    if jwt_session.present?
      JwtSession.where(jwt_id: @jwt_opts[:jti]).delete_all
      cookies.delete :access_token
    end
    redirect_to '/login?logout=true'
  end
end
