class MessagesController < ApplicationController
  include EntityContext
  include Api::V1::MessageThread

  before_action :authorize
  before_action :load_message_thread_participant_with_scope, only: [:show]
  before_action :load_message_thread_participant, only: [:mark_as_read, :remove_messages, :destroy]

  def index
    @message_thread_participants = message_thread_participants_scope @context.message_thread_participants
    render json: paginated_json(@message_thread_participants) { |mtp| message_threads_json(mtp, get_includes) }
  end

  def create
    message_thread = create_message_params[:message_thread_id] && MessageThread.find(create_message_params[:message_thread_id])

    # Trying to create a message on a thread you don't belong to? For shame!
    raise CanCan::AccessDenied if message_thread && !message_thread.message_thread_participants.where(entity_type: @context.class_type, entity_id: @context.id).exists?

    recipients = create_message_params[:recipients] && message_thread.blank? && create_message_params[:recipients].uniq.map { |r| instantiated_object(r[:type], r[:id]) }.compact
    recipients ||= []

    if recipients.blank? && message_thread.blank?
      return render json: { message: 'message[recipients] must include at least 1 valid recipient' }, status: :bad_request
    end
    recipients << @context # current context needs to be added as a recipient as well to track workflow_state

    message_thread ||= MessageThread.new subject: create_message_params[:subject]
    if message_thread.new_record?
      # if message_thread is a new record, we need to populate it with the recipients specified by the user
      # otherwise, there are already participants attached to this thread which will be used by each individual message
      recipients.each { |recipient| message_thread.add_participant(recipient) }
    end

    message = message_thread.messages.new body: create_message_params[:body], author: @context

    if message_thread.save
      # mark message thread as unread for all participants other than current context
      message_thread.message_thread_participants.where("message_thread_participants.entity_type != ? OR message_thread_participants.entity_id != ?", @context.class_type, @context.id).update_all workflow_state: 'unread'

      # pull a fresh copy of the participants association so rails will properly eager load associations
      message_thread_participants = MessageThreadParticipant.where(message_thread: message_thread, entity_type: @context.class_type, entity_id: @context.id)
      message_thread_participants.first.mark_as_read

      render json: message_threads_json(message_thread_participants_scope(message_thread_participants)).first, status: :ok
    else
      render json: message_thread.errors
    end
  end

  def show
    render json: message_thread_json(@message_thread_participant)
  end

  def mark_as_read
    @message_thread_participant.mark_as_read
    load_message_thread_participant_with_scope
    render json: message_thread_json(@message_thread_participant)
  end

  def remove_messages
    if params[:remove].present?
      @message_thread_participant.message_participants.where(message_id: params[:remove]).destroy_all
    end
    if @message_thread_participant.message_participants.exists?
      load_message_thread_participant_with_scope
      render json: message_thread_json(@message_thread_participant)
    else
      head :no_content
    end
  end

  def destroy
    @message_thread_participant.destroy
    head :no_content
  end

  def load_message_thread_participant
    @message_thread_participant = @context.message_thread_participants.find_by!(message_thread_id: params[:id])
  end

  def load_message_thread_participant_with_scope
    @message_thread_participant = message_thread_participants_scope(@context.message_thread_participants).find_by!(message_thread_id: params[:id])
  end

  def message_thread_participants_scope(participants)
    participants.includes(message_thread: { messages: :message_participants }).where(message_participants: { entity_id: @context.id, entity_type: @context.class_type })
  end

  def authorize
    raise CanCan::AccessDenied unless @context.entity_user_for_user(current_user)
  end

  private
  def create_message_params
    params.require(:message).permit(:message_thread_id, :subject, :body, recipients: [:id, :type])
  end
end
