require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:message)).to be_valid
  end

  describe 'should have valid associations' do
    it { should belong_to(:message_thread).inverse_of(:messages) }
    it { should belong_to(:author) }
    it { should have_many(:message_participants).dependent(:destroy) }
  end

  describe 'should have valid validations' do
    it { should validate_presence_of(:message_thread) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
  end

  describe 'should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

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
