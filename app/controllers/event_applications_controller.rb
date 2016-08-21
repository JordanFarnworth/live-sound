class EventApplicationsController < ApplicationController
  include Api::V1::EventApplication
  include EntityContext
  include EventContext

  before_action :find_event_application, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)
  authorize_resource except: [:index]

  def index
    @event_applications = @context.event_applications
    render json: paginated_json(@event_applications) { |event_applications| event_applications_json(event_applications) }
  end

  def show
    render json: event_application_json(@event_application, get_includes), status: :ok
  end

  def create
    @event_application = EventApplication.new event_application_params
    if @event_application.save
      render json: event_application_json(@event_application, get_includes), status: :ok
    else
      render json: {error: "#{@event_application.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @event_application.update update_application_params
      render json: event_application_json(@event_application, get_includes), status: :ok
    else
      render json: {error: @event_application.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @event_application.destroy
    head :no_content
  end

  private

  def find_event_application
    @event_application = EventApplication.find params[:id] || params[:event_application_id]
  end

  def event_application_params
    params.require(:event_application).permit(:event_id, :workflow_state, :applicable_type, :application_type, :applicable_id, :created_at, :updated_at)
  end

  def update_application_params
    params.permit(:id, :event_id, :workflow_state, :applicable_type, :application_type, :applicable_id, :created_at, :updated_at)
  end

end
