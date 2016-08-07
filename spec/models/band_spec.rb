require 'rails_helper'

describe Band, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:band)).to be_valid
  end

  let(:band){ FactoryGirl.build(:band) }

  it { should have_db_column(:deleted_at) }
  it { should serialize(:settings) }
  it { should serialize(:social_media) }
end
