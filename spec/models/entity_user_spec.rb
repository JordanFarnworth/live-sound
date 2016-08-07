require 'rails_helper'

describe EntityUser, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:entity_user)).to be_valid
  end

  let(:entity_user){ FactoryGirl.build(:entity_user) }
  it { should belong_to(:user) }
  it { should belong_to(:userable) }
end
