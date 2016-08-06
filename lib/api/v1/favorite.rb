module Api::V1::Favorite
  include Api::V1::Json

  def favorite_json(favorite, includes = [])
    attributes = %w(id favoriterable_type favoriterable_id favoritable_type favoritable_id workflow_state created_at)

    api_json(favorite, only: attributes)
  end

  def favorites_json(favorites, includes = [])
    favorites.map { |e| favorite_json e, includes }
  end
end
