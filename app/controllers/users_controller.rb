class UsersController < ApplicationController
  include Api::V1::User

  before_action :find_users, only: :index
  before_action :find_user, only: [:show, :update, :destroy]

  def index
    render json: paginated_json(@users) { |users| users_json(users, get_includes) }, status: :ok
  end

  def show
    render json: user_json(@user, get_includes), status: :ok
  end

  def update
    if @user.update user_params
      render json: user_json(@user), status: :ok
    else
      render json: {error: "#{@user.errors.full_messages}"}, status: :bad_request
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      render json: user_json(@user), status: :ok
    else
      render json: {errors: "#{@user.errors.full_messages}"}, status: :bad_request
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private
  def find_users
    @users = User.all
  end

  def find_user
    @user = User.find params[:id] || params[:user_id]
  end

  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :workflow_state, :settings, :single_user, :address, :longitude, :latitude, :provider, :uid, :facebook_image_url)
  end

end
