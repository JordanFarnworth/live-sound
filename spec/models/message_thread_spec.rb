require 'rails_helper'

RSpec.describe MessageThread, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:message_thread)).to be_valid
  end

  describe 'it should have valid associations' do
    it { should have_many(:messages).dependent(:destroy).inverse_of(:message_thread) }
    it { should have_many(:message_thread_participants).dependent(:destroy).inverse_of(:message_thread) }
  end

  describe 'it should have valid validations' do
    it { should validate_presence_of(:subject) }
  end

  describe 'it should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'it should accept nested attributes' do
    it { should accept_nested_attributes_for(:messages) }
    it { should accept_nested_attributes_for(:message_thread_participants) }
  end
end
