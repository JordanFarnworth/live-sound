require 'rails_helper'

describe Enterprise, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:enterprise)).to be_valid
  end

  describe 'should act as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'should serialize attributes' do
    it { should serialize(:settings) }
    it { should serialize(:social_media) }
  end
end
