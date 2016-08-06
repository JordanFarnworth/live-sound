class PrivatePartiesController < ApplicationController
  include Api::V1::PrivateParty

  load_resource only: :index

  before_action :find_private_party, only: [:show, :destroy, :update]
  before_action :find_private_parties, only: :index

  def index
    render json: paginated_json(@private_parties) { |pp| private_parties_json(pp, get_includes) }, status: :ok
  end

  def show
    render json: private_party_json(@private_party, get_includes), status: :ok
  end

  def new
    @private_party = PrivateParty.new
  end

  def create
    @private_party = PrivateParty.new private_party_params
    if @private_party.save
      render json: private_party_json(@private_party), status: :ok
    else
      render json: { errors: "#{@private_party.errors.full_messages}" }, status: :bad_request
    end
  end

  def update
    if @private_party.update private_party_params
      render json: private_party_json(@private_party), status: :ok
    else
      render json: {errors: "#{@private_party.errors.full_messages}"}, status: :bad_request
    end
  end

  def destroy
    @private_party.destroy
    head :no_content
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
                                 :workflow_state, :settings, :created_at, :updated_at)
  end

end
