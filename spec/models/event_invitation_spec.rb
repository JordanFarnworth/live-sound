require 'rails_helper'

describe EventInvitation, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event_invitation)).to be_valid
  end

  describe 'should have valid validations' do
    it { should validate_presence_of(:event_id) }
    it 'validates uniqueness of event id' do
      FactoryGirl.create(:event_invitation)
      should validate_uniqueness_of(:event_id).scoped_to(:invitable_id, :invitable_type)
    end
    it { should validate_presence_of(:invitable_id) }
    it { should validate_presence_of(:invitable_type) }
    it 'should validate inclusion of invitable type' do
      FactoryGirl.create(:event_invitation)
      should validate_inclusion_of(:invitable_type).in_array(Entityable::ENTITYABLE_CLASSES)
    end
    it { should validate_presence_of(:invitation_type) }
    it { should validate_inclusion_of(:invitation_type).in_array(%w[as_performer as_guest]) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.create(:event_invitation)
      should validate_inclusion_of(:workflow_state).in_array(%w[pending accepted declined])
    end
  end

  describe 'should have valid associations' do
    it { should belong_to(:event) }
    it { should belong_to(:invitable) }
  end
end
