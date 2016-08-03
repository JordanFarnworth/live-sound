class EnterprisesController < ApplicationController
  include Api::V1::Enterprise

  before_action :find_enterprise, only: [:show, :edit, :delete, :update]
  before_action :find_active_enterprises, only: :index

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

  def edit
  end

  def create
  end

  def update
  end

  def delete
  end

  private
  def find_active_enterprises
    @enterprises = Enterprise.active
  end

  def find_enterprise
    @enterprise = Enterprise.find params[:id] || params[:enterprise_id]
  end

end
