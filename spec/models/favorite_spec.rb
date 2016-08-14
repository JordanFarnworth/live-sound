require 'rails_helper'

describe Favorite, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:favorite)).to be_valid
  end

  describe 'associations should be valid' do
    it { should belong_to(:favoritable)}
    it { should belong_to(:favoriterable)}
  end

  describe 'validations should be valid' do
    it { should validate_presence_of(:favoriterable_type) }
    it { should validate_inclusion_of(:favoriterable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_uniqueness_of(:favoriterable_type).scoped_to([:favoriterable_id, :favoritable_type, :favoritable_id]) }
    it { should validate_presence_of(:favoriterable_id) }
    it { should validate_presence_of(:favoritable_type) }
    it { should validate_inclusion_of(:favoritable_type).in_array(Entityable::ENTITYABLE_CLASSES) }
    it { should validate_presence_of(:favoritable_id) }
  end
end
