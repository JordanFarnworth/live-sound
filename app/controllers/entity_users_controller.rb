class EntityUsersController < ApplicationController
  include Api::V1::EntityUser
  include EntityContext

  before_action :find_entity_user, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @entity_users = EntityUser.includes(:user).where(userable: @context)
    render json: paginated_json(@entity_users) { |entity_users| entity_users_json(entity_users) }
  end

  def show
    render json: entity_user_json(@entity_user, get_includes), status: :ok
  end

  def create
    @entity_user = EntityUser.new entity_user_params
    if @entity_user.save
      render json: entity_user_json(@entity_user, get_includes), status: :ok
    else
      render json: {error: "#{@entity_user.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @entity_user.update entity_user_params
      render json: entity_user_json(@entity_user, get_includes), status: :ok
    else
      render json: {error: @entity_user.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @entity_user.destroy
    head :no_content
  end

  private

  def find_entity_user
    @entity_user = EntityUser.find params[:id] || params[:entity_user_id]
  end

  def entity_user_params
      params.require(:entity_user).permit(:id, :user_id, :userable_id, :userable_type, :workflow_state)
  end
end
