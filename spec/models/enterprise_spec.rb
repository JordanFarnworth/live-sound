require 'rails_helper'

describe Enterprise, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:enterprise)).to be_valid
  end

  let(:enterprise){ FactoryGirl.build(:enterprise) }

  it { should serialize(:settings) }
  it { should serialize(:social_media) }
end
