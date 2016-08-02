class SessionsController < ApplicationController
  include Api::V1::User
  include Api::V1::Entities
  include Api::V1::Enterprise
  include Api::V1::PrivateParty
  include Api::V1::Band

  def create
    auth = OpenStruct.new()
    auth.provider = env["omniauth.auth"]["provider"]
    auth.uid = env["omniauth.auth"]["uid"]
    auth.name = env["omniauth.auth"]["info"]["name"]
    auth.image = env["omniauth.auth"]["info"]["image"]
    auth.oauth_token = env["omniauth.auth"]["credentials"]["token"]
    auth.oauth_expires_at = env["omniauth.auth"]["credentials"]["expires_at"]
    user = User.from_omniauth(auth)
    session[:user_id] = user.id
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
    session[:user_id] = nil
    redirect_to '/login?logout=true'
  end
end
