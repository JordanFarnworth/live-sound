class ReviewsController < ApplicationController
  include Api::V1::Review
  include EntityContext

  before_action :find_review, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @reviews = Review.includes(:reviewerable).where(reviewable: @context)
    render json: paginated_json(@reviews) { |reviews| reviews_json(reviews) }
  end

  def show
    render json: review_json(@review, get_includes), status: :ok
  end

  def create
    @review = Review.new review_params
    if @review.save
      render json: review_json(@review, get_includes), status: :ok
    else
      render json: {error: "#{@review.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @review.update review_params
      render json: review_json(@review, get_includes), status: :ok
    else
      render json: {error: @review.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @review.destroy
    head :no_content
  end

  private

  def find_review
    @review = Review.find params[:id] || params[:review_id]
  end

  def review_params
      params.require(:review).permit(:id, :reviewerable_type, :reviewerable_id, :reviewable_type, :reviewable_id, :text, :rating, :workflow_state)
  end

end
