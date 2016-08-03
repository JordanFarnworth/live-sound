class PrivatePartiesController < ApplicationController
  include Api::V1::PrivateParty

  before_action :find_private_party, only: [:show, :edit, :delete, :update]
  before_action :find_active_private_parties, only: :index

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

  def edit
  end

  def create
  end

  def update
  end

  def delete
  end

  private
  def find_active_private_parties
    @private_parties = PrivateParty.active
  end

  def find_private_party
    @private_party = PrivateParty.find params[:id] || params[:private_party_id]
  end

end
