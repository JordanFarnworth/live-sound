require 'rails_helper'

describe User, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe 'acts as paranoid' do
    it { should have_db_column(:deleted_at) }
  end

  describe 'has secure password' do
    it { should have_secure_password }
  end

  describe 'has valid validations' do
    it { should validate_uniqueness_of(:uid) }
    it { should allow_value(nil).for(:uid) }
    it { should validate_inclusion_of(:workflow_state).in_array(%w[pending_approval active]) }
    it { should allow_value("sample@email.com").for(:email) }
    it { should_not allow_value("sample").for(:email) }
  end

  describe 'should serialize attributes' do
    it { should serialize(:settings) }
  end

  describe 'email_blank? returns value' do
    it 'should return value' do
      user = FactoryGirl.build(:user)
      response = user.email_blank?
      expect(response).to be false
    end
  end

  describe 'class methods' do
    let!(:user) {FactoryGirl.create(:user, display_name: "test name")}

    it 'should return the users display name' do
      expect(user.name).to eq user.display_name
    end
  end
end
