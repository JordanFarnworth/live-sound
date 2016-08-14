require 'rails_helper'

describe EventMember, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:event_member)).to be_valid
  end

  describe 'should have valid associations' do
    it { should belong_to(:event) }
    it { should belong_to(:memberable) }
  end

  describe 'should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'should have valid validations' do
    it { should validate_presence_of(:event_id) }
    it 'validates uniquness of event id' do
      FactoryGirl.create(:event_member)
      should validate_uniqueness_of(:event_id).scoped_to(:memberable_id, :memberable_type)
    end
    it { should validate_presence_of(:memberable_id) }
    it { should validate_presence_of(:memberable_type) }
    it { should validate_inclusion_of(:memberable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_presence_of(:member_type) }
    it { should validate_inclusion_of(:member_type).in_array(%w[owner performer attendee admin]) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.build(:event_member)
      should validate_inclusion_of(:workflow_state).in_array(%w[active pending])
    end
  end
end
