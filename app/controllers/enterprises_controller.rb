class EnterprisesController < ApplicationController
  include Api::V1::Enterprise

  load_resource only: :index

  before_action :find_enterprise, only: [:show, :destroy, :update]
  before_action :find_enterprises, only: :index

  def index
    render json: paginated_json(@enterprises) { |e| enterprises_json(e, get_includes) }, status: :ok
  end

  def show
    render json: enterprise_json(@enterprise, get_includes), status: :ok
  end

  def create
    @enterprise = Enterprise.new enterprise_params
    if @enterprise.save
      render json: enterprise_json(@enterprise), status: :ok
    else
      render json: { errors: "#{@enterprise.errors.full_messages}" }, status: :bad_request
    end
  end

  def update
    if @enterprise.update enterprise_params
      render json: enterprise_json(@enterprise), status: :ok
    else
      render json: {errors: "#{@enterprise.errors.full_messages}"}, status: :bad_request
    end
  end

  def destroy
    @enterprise.destroy
    head :no_content
  end

  private

  def find_enterprise
    @enterprise = Enterprise.find params[:id] || params[:enterprise_id]
  end

  def find_enterprises
    @enterprises = Enterprise.all
  end

  def enterprise_params
    params.require(:enterprise).permit(:name, :description, :social_media, :deleted_at, :address, :longitude, :latitude,
                                 :braintree_customer_id, :subscription_expires_at, :youtube_link, :email, :genre, :phone_number,
                                 :workflow_state, :settings, :created_at, :updated_at)
  end

end
