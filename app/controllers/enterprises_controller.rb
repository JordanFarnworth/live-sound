class EnterprisesController < ApplicationController
  include Api::V1::Enterprise

  load_resource only: :index

  before_action :find_enterprise, only: [:show, :destroy, :update]
  before_action :find_enterprises, only: :index

  def index
    respond_to do |format|
      format.json do
        render json: paginated_json(@enterprises) { |e| enterprises_json(e, get_includes) }, status: :ok
      end
      format.html do
        @enterprises
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: enterprise_json(@enterprise, get_includes), status: :ok
      end
      format.html do
        @enterprise
      end
    end
  end

  def new
    @enterprise = Enterprise.new
  end

  def create
    @enterprise = Enterprise.new enterprise_params
    respond_to do |format|
      format.json do
        if @enterprise.save
          render json: enterprise_json(@enterprise), status: :ok
        else
          render json: { errors: "#{@enterprise.errors.full_messages}" }, status: :bad_request
        end
      end
    end
  end

  def update
    @enterprise.update enterprise_params
    respond_to do |format|
      if @enterprise.save
        format.json { render json: enterprise_json(@enterprise), status: :ok }
      else
        format.json { render json: {errors: "#{@enterprise.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def destroy
    @enterprise.destroy
    respond_to do |format|
      unless @enterprise.deleted_at == nil
        format.json { render json: enterprise_json(@enterprise), status: :ok }
      else
        format.json { render json: {errors: "#{@enterprise.errors.full_messages}"}, status: :bad_request }
      end
    end
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
                                 :state, :settings, :created_at, :updated_at)
  end

end
