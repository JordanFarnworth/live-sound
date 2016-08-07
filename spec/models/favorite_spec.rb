require 'rails_helper'

describe Favorite, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:favorite)).to be_valid
  end

  let(:favorite){ FactoryGirl.build(:favorite)}

  it { should belong_to(:favoritable)}
  it { should belong_to(:favoriterable)}
end
