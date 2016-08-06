class EntityUsersController < ApplicationController
  include Api::V1::EntityUser
  include EntityContext

  before_action :find_entity_user, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @entity_users = EntityUser.includes(:user).where(userable: @context)
    render json: paginated_json(@entity_users)
  end

  def show
    respond_to do |format|
      format.json {render json: entity_user_json(@entity_user, get_includes), status: :ok }
      format.html {@entity_user}
    end
  end

  def create
    @entity_user = EntityUser.new entity_user_params
    respond_to do |format|
      if @entity_user.valid?
        @entity_user.save
        format.json {render json: entity_user_json(@entity_user, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@entity_user.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @entity_user.update entity_user_params
    respond_to do |format|
      if @entity_user.valid?
        @entity_user.save
        format.json {render json: entity_user_json(@entity_user, get_includes), status: :ok }
      else
        format.json {render json: {error: @entity_user.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @entity_user.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_entity_user
    @entity_user = EntityUser.find params[:id] || params[:entity_user_id]
  end

  def entity_user_params
      params.require(:entity_user).permit(:id, :user_id, :userable_id, :userable_type, :workflow_state)
  end
end
