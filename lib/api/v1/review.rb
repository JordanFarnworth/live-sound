module Api::V1::Review
  include Api::V1::Json
  include Api::V1::Entities

  def review_json(review, includes = [])
    attributes = %w(id text rating created_at updated_at workflow_state)

    api_json(review, only: attributes).tap do |hash|
      hash['reviewer'] = entity_json(review.reviewerable) if includes.include?('reviewer')
      hash['reviewee'] = entity_json(review.reviewable) if includes.include?('reviewee')
    end
  end

  def reviews_json(reviews, includes = [])
    reviews = reviews.includes(:reviewerable) if includes.include?('reviewer')
    reviews = reviews.includes(:reviewable) if includes.include?('reviewee')
    reviews.map { |e| review_json e, includes }
  end
end
