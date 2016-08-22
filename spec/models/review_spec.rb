require 'rails_helper'

describe Review, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:review)).to be_valid
  end

  describe 'should have valid validations' do
    it 'should have a rating between 1 and 5' do
      should validate_numericality_of(:rating).
        is_less_than_or_equal_to(5).
        is_greater_than_or_equal_to(1)
    end
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:reviewable_id) }
    it 'should validate uniqueness of reviewable id' do
      FactoryGirl.create(:review)
      should validate_uniqueness_of(:reviewable_id).scoped_to(:reviewable_type, :reviewerable_id, :reviewerable_type)
    end
    it { should validate_presence_of(:reviewable_type) }
    it { should validate_inclusion_of(:reviewable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_presence_of(:reviewerable_id) }
    it { should validate_presence_of(:reviewerable_type) }
    it { should validate_inclusion_of(:reviewerable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.build(:review)
      should validate_inclusion_of(:workflow_state).in_array(%w[unpublished active])
    end
  end

  describe 'should have valid associations' do
    it { should belong_to(:reviewable) }
    it { should belong_to(:reviewerable) }
  end
end
