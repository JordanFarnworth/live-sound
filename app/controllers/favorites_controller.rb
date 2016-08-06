class FavoritesController < ApplicationController
  include Api::V1::Favorite
  include EntityContext

  before_action :find_favorite, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @favorites = Favorite.includes(:favoriterable).where(favoriteable: @context)
    render json: paginated_json(@favorites)
  end

  def show
    respond_to do |format|
      format.json {render json: favorite_json(@favorite, get_includes), status: :ok }
      format.html {@favorite}
    end
  end

  def create
    @favorite = Favorite.new favorite_params
    respond_to do |format|
      if @favorite.valid?
        @favorite.save
        format.json {render json: favorite_json(@favorite, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@favorite.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @favorite.update favorite_params
    respond_to do |format|
      if @favorite.valid?
        @favorite.save
        format.json {render json: favorite_json(@favorite, get_includes), status: :ok }
      else
        format.json {render json: {error: @favorite.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @favorite.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_favorite
    @favorite = Favorite.find params[:id] || params[:favorite_id]
  end

  def favorite_params
      params.require(:favorite).permit(:id, :favoriterable_type, :favoriterable_id, :favoritable_type, :favoritable_id, :workflow_state)
  end

end
