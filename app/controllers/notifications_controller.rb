class NotificationsController < ApplicationController
  include Api::V1::Notification
  include EntityContext

  before_action :find_notification, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @notifications = Notification.includes(:contextable).where(notifiable: @context)
    render json: paginated_json(@notifications)
  end

  def show
    respond_to do |format|
      format.json {render json: notification_json(@notification, get_includes), status: :ok }
      format.html {@notification}
    end
  end

  def create
    @notification = Notification.new notification_params
    respond_to do |format|
      if @notification.valid?
        @notification.save
        format.json {render json: notification_json(@notification, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@notification.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @notification.update notification_params
    respond_to do |format|
      if @notification.valid?
        @notification.save
        format.json {render json: notification_json(@notification, get_includes), status: :ok }
      else
        format.json {render json: {error: @notification.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @notification.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_notification
    @notification = Notification.find params[:id] || params[:notification_id]
  end

  def notification_params
      params.require(:notification).permit(:id, :notifiable_type, :notifiable_id, :contextable_type, :contextable_id, :description, :workflow_state)
  end

end
