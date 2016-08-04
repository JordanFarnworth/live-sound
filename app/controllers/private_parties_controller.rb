class PrivatePartiesController < ApplicationController
  include Api::V1::PrivateParty

  load_resource only: :index

  before_action :find_private_party, only: [:show, :destroy, :update]
  before_action :find_private_parties, only: :index

  def index
    respond_to do |format|
      format.json do
        render json: paginated_json(@private_parties) { |pp| private_parties_json(pp, get_includes) }, status: :ok
      end
      format.html do
        @private_parties
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: private_party_json(@private_party, get_includes), status: :ok
      end
      format.html do
        @private_party
      end
    end
  end

  def new
    @private_party = PrivateParty.new
  end

  def create
    @private_party = PrivateParty.new private_party_params
    respond_to do |format|
      format.json do
        if @private_party.save
          render json: private_party_json(@private_party), status: :ok
        else
          render json: { errors: "#{@private_party.errors.full_messages}" }, status: :bad_request
        end
      end
    end
  end

  def update
    @private_party.update private_party_params
    respond_to do |format|
      if @private_party.save
        format.json { render json: private_party_json(@private_party), status: :ok }
      else
        format.json { render json: {errors: "#{@private_party.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def destroy
    @private_party.destroy
    respond_to do |format|
      unless @private_party.deleted_at == nil
        format.json { render json: private_party_json(@private_party), status: :ok }
      else
        format.json { render json: {errors: "#{@private_party.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  private
  def find_private_party
    @private_party = PrivateParty.find params[:id] || params[:private_party_id]
  end

  def find_private_parties
    @private_parties = PrivateParty.all
  end

  def private_party_params
    params.require(:private_party).permit(:name, :description, :social_media, :deleted_at, :address, :longitude, :latitude,
                                 :braintree_customer_id, :subscription_expires_at, :youtube_link, :email, :genre, :phone_number,
                                 :state, :settings, :created_at, :updated_at)
  end

end
