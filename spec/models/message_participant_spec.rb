require 'rails_helper'

RSpec.describe MessageParticipant, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:message_participant)).to be_valid
  end

  describe 'should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'should have valid associations' do
    it { should belong_to(:message) }
    it { should belong_to(:entity) }
  end

  describe 'should have valid validations' do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:entity) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.create(:message_participant)
      should validate_inclusion_of(:workflow_state).in_array(%w[unread read])
    end
    it 'validates uniquness of message id' do
      FactoryGirl.create(:message_participant)
      should validate_uniqueness_of(:message_id).scoped_to(:entity_id, :entity_type)
    end
  end
end
