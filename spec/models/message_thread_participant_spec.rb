require 'rails_helper'

RSpec.describe MessageThreadParticipant, type: :model do
  describe 'has valid associations' do
    it { should belong_to(:message_thread).inverse_of(:message_thread_participants) }
    it { should belong_to(:entity) }
  end

  describe 'has valid validations' do
    it { should validate_presence_of(:message_thread) }
    it { should validate_presence_of(:entity) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.create(:message_participant)
      should validate_inclusion_of(:workflow_state).in_array(%w[unread read])
    end
  end

  describe 'acts as paranoid' do
    it { should have_db_column(:deleted_at)}
  end

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
