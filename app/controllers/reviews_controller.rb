class ReviewsController < ApplicationController
  include Api::V1::Review
  include EntityContext

  before_action :find_review, only: [:show, :update, :destroy]
  authorize_resource except: [:index]

  def index
    @reviews = Review.active.includes(:reviewerable).where(reviewable: @context)
    render json: paginated_json(@reviews) { |reviews| reviews_json(reviews, get_includes) }
  end

  def show
    render json: review_json(@review, get_includes), status: :ok
  end

  def create
    @review = @context.reviews.new create_review_params

    if @review.reviewerable && !@review.reviewerable.entity_user_for_user(current_or_blank_user)
      return render json: { message: 'You cannot create a review as an entity with which you have no affiliation' }, status: :bad_request
    end

    if @review.save
      render json: review_json(@review, get_includes), status: :ok
    else
      render json: @review.errors, status: :bad_request
    end
  end

  def update
    if @review.update update_review_params
      render json: review_json(@review, get_includes), status: :ok
    else
      render json: @review.errors, status: :bad_request
    end
  end

  def destroy
    @review.destroy
    head :no_content
  end

  private

  def find_review
    @review = Review.active.find params[:review_id] || params[:id]
  end

  def create_review_params
    params.require(:review).permit(:reviewerable_id, :reviewerable_type, :text, :rating, :workflow_state)
  end

  def update_review_params
    params.require(:review).permit(:text, :rating, :workflow_state)
  end

end
