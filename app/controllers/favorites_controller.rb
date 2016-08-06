class FavoritesController < ApplicationController
  include Api::V1::Favorite
  include EntityContext

  before_action :find_favorite, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @favorites = Favorite.includes(:favoriterable).where(favoriteable: @context)
    render json: paginated_json(@favorites) { |favorites| favorites_json(favorites) }
  end

  def show
    render json: favorite_json(@favorite, get_includes), status: :ok
  end

  def create
    @favorite = Favorite.new favorite_params
    if @favorite.save
      render json: favorite_json(@favorite, get_includes), status: :ok
    else
      render json: {error: "#{@favorite.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @favorite.update favorite_params
      render json: favorite_json(@favorite, get_includes), status: :ok
    else
      render json: {error: @favorite.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @favorite.destroy
    head :no_content
  end

  private

  def find_favorite
    @favorite = Favorite.find params[:id] || params[:favorite_id]
  end

  def favorite_params
      params.require(:favorite).permit(:id, :favoriterable_type, :favoriterable_id, :favoritable_type, :favoritable_id, :workflow_state)
  end

end
