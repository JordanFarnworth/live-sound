require 'rails_helper'

describe EventMembership, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:event_membership)).to be_valid
  end

  describe 'it should have valid associations' do
    it { should belong_to(:event) }
    it { should belong_to(:memberable) }
  end

  describe 'it should have valid validations' do
    it { should validate_presence_of(:event_id) }
    it 'should validate uniquness of event id' do
      FactoryGirl.create(:event_membership)
      should validate_uniqueness_of(:event_id).scoped_to(:memberable_id, :memberable_type, :role)
    end
    it { should validate_presence_of(:memberable_id) }
    it { should validate_inclusion_of(:workflow_state).in_array(%w[invited active pending declined]) }
    it { should validate_presence_of(:memberable_type) }
    it { should validate_inclusion_of(:memberable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.create(:event_membership)
      should validate_inclusion_of(:workflow_state).in_array(%w[invited active pending declined])
    end
    it { should validate_inclusion_of(:role).in_array(%w[owner admin performer attendee]) }
  end
end
