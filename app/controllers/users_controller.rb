class UsersController < ApplicationController
  include Api::V1::User

  before_action :find_users, only: :index
  before_action :find_user, only: [:show, :update, :destroy]

  def index
    respond_to do |format|
      format.json do
        render json: paginated_json(@users) { |users| users_json(users, get_includes) }, status: :ok
      end
      format.html do
        @users
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: user_json(@user, get_includes), status: :ok
      end
      format.html do
        @user
      end
    end
  end

  def update
    @user.update user_params
      respond_to do |format|
        if @user.save
          format.json { render json: user_json(@user), status: :ok  }
        else
          format.json { render json: {error: "#{@user.errors.full_messages}", status: :bad_request}}
        end
      end
  end

  def create
    @user = User.new user_params
    respond_to do |format|
      if @user.save
        format.json { render json: user_json(@user), status: :ok }
      else
        format.json { render json: {errors: "#{@user.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      unless @band.deleted_at == nil
        format.json { render json: band_json(@band), status: :ok }
      else
        format.json { render json: {errors: "#{@band.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  private
  def find_users
    @users = User.all
  end

  def find_user
    @user = User.find params[:id] || params[:user_id]
  end

  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :state, :settings, :single_user, :address, :longitude, :latitude, :provider, :uid, :facebook_image_url)
  end

end
