require 'rails_helper'

describe PrivateParty, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:private_party)).to be_valid
  end

  let(:private_party){ FactoryGirl.build(:private_party) }

  it { should have_many(:events).through(:event_members) }
  it { should have_many(:event_members) }
  it { should have_db_column(:deleted_at) }
  it { should serialize(:settings) }
  it { should serialize(:social_media) }
end
