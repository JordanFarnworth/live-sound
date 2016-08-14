require 'rails_helper'

describe PrivateParty, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:private_party)).to be_valid
  end

  describe 'should have valid validations' do
    it { should have_many(:events).through(:event_members) }
    it { should have_many(:event_members) }
  end

  describe 'should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'should serialize attributes' do
    it { should serialize(:settings) }
    it { should serialize(:social_media) }
  end
end
