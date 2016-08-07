require 'rails_helper'

describe Review, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:review)).to be_valid
  end

  let(:review){ FactoryGirl.build(:review) }

  it { should belong_to(:reviewable) }
end
