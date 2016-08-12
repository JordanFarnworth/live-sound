module Api::V1::Message
  include Api::V1::Json
  include Api::V1::Entities

  def message_json(message, includes = [])
    attributes = %w(id body author_id author_type created_at updated_at)

    api_json(message, only: attributes).tap do |hash|
      hash['workflow_state'] = message.message_participants.first.workflow_state
    end
  end

  def messages_json(messages, includes = [])
    messages.map { |m| message_json(m, includes) }
  end
end
