require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:thread) { create :full_message_thread, messages_count: 0 }

  it 'creates message_participants from parent thread' do
    message = create :message, message_thread: thread
    expect(message.message_participants.count).to eql thread.message_thread_participants.count
  end

  it 'marks a message participant as read if entity is the message\'s author' do
    message = create :message, message_thread: thread, author: thread.message_thread_participants.first.entity
    author_participant = message.message_participants.find_by entity: message.author
    expect(author_participant.workflow_state).to eql 'read'
  end
end
