module Api::V1::MessageThread
  include Api::V1::Json
  include Api::V1::Entities
  include Api::V1::Message

  def message_thread_json(message_thread_participant, includes = [])
    attributes = %w(entity_id entity_type workflow_state)

    api_json(message_thread_participant, only: attributes).tap do |hash|
      hash.merge!(_frd_message_thread_json(message_thread_participant.message_thread, includes))
      hash['messages'] = messages_json(message_thread_participant.message_thread.messages, includes)
    end
  end

  def message_threads_json(message_thread_participants, includes = [])
    message_thread_participants.map { |mt| message_thread_json(mt, includes) }
  end

  private
  # Different from from #message_thread_json as it's more performant to use the participants as the primary
  # object, and add message threads later
  def _frd_message_thread_json(message_thread, includes = [])
    attributes = %w(id subject created_at updated_at)
    api_json(message_thread, only: attributes)
  end
end
