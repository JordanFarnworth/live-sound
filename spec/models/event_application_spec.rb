require 'rails_helper'

describe EventApplication, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event_application)).to be_valid
  end

  describe 'validations should be valid' do
    it { should validate_presence_of(:event_id) }
    it 'should validate uniqueness of event id' do
      FactoryGirl.create(:event_application)
      should validate_uniqueness_of(:event_id).scoped_to(:applicable_id, :applicable_type)
    end
    it { should validate_presence_of(:applicable_id) }
    it { should validate_presence_of(:applicable_type) }
    it { should validate_inclusion_of(:applicable_type).in_array(%w[Band User]) }
    it { should validate_presence_of(:application_type) }
    it { should validate_inclusion_of(:application_type).in_array(%w[as_performer]) }
    it 'should validate inclusion of workflow state' do
      FactoryGirl.build(:event_application)
      should validate_inclusion_of(:workflow_state).in_array(%w[pending accepted declined])
    end
  end

  describe 'associations should be valid' do
    it { should belong_to(:event) }
    it { should belong_to(:applicable) }
  end
end
