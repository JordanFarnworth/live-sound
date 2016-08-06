class NotificationsController < ApplicationController
  include Api::V1::Notification
  include EntityContext

  before_action :find_notification, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @notifications = Notification.includes(:contextable).where(notifiable: @context)
    render json: paginated_json(@notifications) { |notifications| notifications_json(notifications) }
  end

  def show
    render json: notification_json(@notification, get_includes), status: :ok
  end

  def create
    @notification = Notification.new notification_params
    if @notification.save
      render json: notification_json(@notification, get_includes), status: :ok
    else
      render json: {error: "#{@notification.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @notification.update notification_params
      render json: notification_json(@notification, get_includes), status: :ok
    else
      render json: {error: @notification.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @notification.destroy
    head :no_content
  end

  private

  def find_notification
    @notification = Notification.find params[:id] || params[:notification_id]
  end

  def notification_params
      params.require(:notification).permit(:id, :notifiable_type, :notifiable_id, :contextable_type, :contextable_id, :description, :workflow_state)
  end

end
