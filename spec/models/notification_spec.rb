require 'rails_helper'

describe Notification, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:notification)).to be_valid
  end

  describe 'should have valid validations' do
    it { should validate_presence_of(:notifiable_id) }
    it { should validate_presence_of(:notifiable_type) }
    it { should validate_inclusion_of(:notifiable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_presence_of(:contextable_id) }
    it { should validate_presence_of(:contextable_type) }
    it { should validate_inclusion_of(:contextable_type).in_array(%w[Event EventInvitation EventApplication Favorite Review EventMember]) }
    it { should validate_presence_of(:workflow_state) }
  end

  describe 'should have valid associations' do
    it { should belong_to(:notifiable) }
    it { should belong_to(:contextable) }
  end
end
