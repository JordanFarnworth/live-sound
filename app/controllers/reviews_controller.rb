class ReviewsController < ApplicationController
  include Api::V1::Review
  include EntityContext

  before_action :find_review, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @reviews = Review.includes(:reviewerable).where(reviewable: @context)
    render json: paginated_json(@reviews)
  end

  def show
    respond_to do |format|
      format.json {render json: review_json(@review, get_includes), status: :ok }
      format.html {@review}
    end
  end

  def create
    @review = Review.new review_params
    respond_to do |format|
      if @review.valid?
        @review.save
        format.json {render json: review_json(@review, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@review.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @review.update review_params
    respond_to do |format|
      if @review.valid?
        @review.save
        format.json {render json: review_json(@review, get_includes), status: :ok }
      else
        format.json {render json: {error: @review.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_review
    @review = Review.find params[:id] || params[:review_id]
  end

  def review_params
      params.require(:review).permit(:id, :reviewerable_type, :reviewerable_id, :reviewable_type, :reviewable_id, :text, :rating, :workflow_state)
  end

end
