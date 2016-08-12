require 'rails_helper'

RSpec.describe MessageThreadParticipant, type: :model do
  let(:thread) { create :full_message_thread }
  let(:thread_participant) { thread.message_thread_participants.first }
  let(:message_participants) { thread_participant.message_participants }

  it 'finds all message_participants for messages in the given thread with the same entity' do
    entity = thread_participant.entity
    message_participants = thread.messages.flat_map { |m| m.message_participants.where(entity: entity) }
    expect(thread_participant.message_participants).to match_array message_participants
  end

  it 'deletes all individual message_participents when the thread participant is deleted' do
    expect(message_participants.count).to eql 5
    thread_participant.destroy
    expect(thread_participant.message_participants.count).to eql 0
  end

  it 'marks all message_participants as read' do
    thread_participant.mark_as_read
    expect(thread_participant.workflow_state).to eql 'read'
    expect(message_participants.pluck(:workflow_state).uniq).to eql ['read']
  end
end
