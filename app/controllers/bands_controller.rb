class BandsController < ApplicationController
  include Api::V1::Band

  load_resource only: :index

  before_action :find_band, only: [:show, :destroy, :update]

  def index
    respond_to do |format|
      format.json do
        render json: paginated_json(@bands) { |bands| bands_json(bands, get_includes) }, status: :ok
      end
      format.html do
        @bands
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: band_json(@band, get_includes), status: :ok
      end
      format.html do
        @band
      end
    end
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new band_params
    respond_to do |format|
      format.json do
        if @band.save
          render json: band_json(@band), status: :ok
        else
          render json: { errors: "#{@band.errors.full_messages}" }, status: :bad_request
        end
      end
    end
  end

  def update
    @band.update band_params
    respond_to do |format|
      if @band.save
        format.json { render json: band_json(@band), status: :ok }
      else
        format.json { render json: {errors: "#{@band.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def destroy
    @band.destroy
    respond_to do |format|
      unless @band.deleted_at == nil
        format.json { render json: band_json(@band), status: :ok }
      else
        format.json { render json: {errors: "#{@band.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  private
  def find_band
    @band = Band.find params[:id] || params[:band_id]
  end

  def band_params
    params.require(:band).permit(:name, :description, :social_media, :deleted_at, :address, :longitude, :latitude,
                                 :braintree_customer_id, :subscription_expires_at, :youtube_link, :email, :genre, :phone_number,
                                 :state, :settings, :created_at, :updated_at)
  end

end
