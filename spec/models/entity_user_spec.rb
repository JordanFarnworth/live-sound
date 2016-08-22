require 'rails_helper'

describe EntityUser, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:entity_user)).to be_valid
  end

  describe 'validations should be valid' do
    it { should validate_presence_of(:user_id) }
    it 'should validate uniqueness of user id' do
      FactoryGirl.create(:user)
      should validate_uniqueness_of(:user_id).scoped_to(:userable_id, :userable_type)
    end
    it { should validate_presence_of(:userable_id) }
    it { should validate_presence_of(:userable_type) }
    it { should validate_inclusion_of(:userable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_inclusion_of(:workflow_state).in_array(%w[suspended active]) }
  end

  describe 'associations should be valid' do
    it { should belong_to(:user) }
    it { should belong_to(:userable) }
  end
end
