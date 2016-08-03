class BandsController < ApplicationController
  include Api::V1::Band

  load_resource only: :index

  before_action :find_band, only: [:show, :edit, :delete, :update]

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

  def edit
  end

  def create
  end

  def update
  end

  def delete
  end

  private
  def find_band
    @band = Band.find params[:id] || params[:band_id]
  end

end
