class FavoritesController < ApplicationController
  include Api::V1::Favorite
  include EntityContext

  before_action :find_favorite, only: [:destroy]
  authorize_resource

  def index
    @favorites = Favorite.where(favoritable: @context)
    render json: paginated_json(@favorites) { |favorites| favorites_json(favorites) }
  end

  def mine
    @favorites = Favorite.where(favoriterable: @context)
    render json: paginated_json(@favorites) { |favorites| favorites_json(favorites) }
  end

  def create
    favoriterable = instantiated_object(favorite_params[:favoriterable_type], favorite_params[:favoriterable_id])

    if favoriterable && !favoriterable.entity_user_for_user(current_or_blank_user)
      return render json: { message: 'You cannot create a favorite as an entity with which you have no affiliation' }, status: :bad_request
    end

    if @context && favoriterable == @context
      return render json: { message: 'You cannot favorite yourself' }, status: :bad_request
    end

    @favorite = Favorite.build_favorite(@context, favoriterable)
    if @favorite.save
      render json: favorite_json(@favorite, get_includes), status: :ok
    else
      render json: @favorite.errors, status: :bad_request
    end
  end

  def destroy
    @favorite.destroy
    head :no_content
  end

  private

  def find_favorite
    @favorite = Favorite.find params[:favorite_id] || params[:id]
  end

  def favorite_params
      params.require(:favorite).permit(:favoriterable_type, :favoriterable_id)
  end

end
