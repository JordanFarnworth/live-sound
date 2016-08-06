class BandsController < ApplicationController
  include Api::V1::Band

  load_resource only: :index

  before_action :find_band, only: [:show, :destroy, :update]

  def index
    render json: paginated_json(@bands) { |bands| bands_json(bands, get_includes) }, status: :ok
  end

  def show
    render json: band_json(@band, get_includes), status: :ok
  end

  def create
    @band = Band.new band_params
    if @band.save
      render json: band_json(@band), status: :ok
    else
      render json: { errors: "#{@band.errors.full_messages}" }, status: :bad_request
    end
  end

  def update
    if @band.update band_params
      render json: band_json(@band), status: :ok
    else
      render json: {errors: "#{@band.errors.full_messages}"}, status: :bad_request
    end
  end

  def destroy
    @band.destroy
    head :no_content
  end

  private
  def find_band
    @band = Band.find params[:id] || params[:band_id]
  end

  def band_params
    params.require(:band).permit(:name, :description, :social_media, :deleted_at, :address, :longitude, :latitude,
                                 :braintree_customer_id, :subscription_expires_at, :youtube_link, :email, :genre, :phone_number,
                                 :workflow_state, :settings, :created_at, :updated_at)
  end

end
