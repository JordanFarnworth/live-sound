module Pagination

  def pagination_params
    opts = { page: 1, per_page: 50 }.merge(params.permit(:page, :per_page).to_h.symbolize_keys)
    opts[:page] = 1 if opts[:page].to_i < 1
    opts[:per_page] = 50 if opts[:per_page].to_i < 1 || opts[:per_page].to_i > 50
    opts
  end

  def paginated_json(collection)
    collection = collection.paginate(pagination_params)
    collection_json = block_given? ? yield(collection) : collection.as_json
    {
      collection: collection_json,
      meta: {
        current_page: pagination_params[:page].to_i,
        total_pages: collection.total_pages,
        per_page: pagination_params[:per_page].to_i,
        total_entries: collection.total_entries
      }
    }
  end
end
