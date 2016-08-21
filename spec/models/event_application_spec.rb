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

  describe 'class methods' do

    describe '#infer_values' do
      let(:event_application){ FactoryGirl.build(:event_application) }

      it 'should set workflow state of event_application' do
        expect(event_application.workflow_state).to eq 'pending'
      end
    end

    describe '#send_notifications!' do
      let!(:event) { FactoryGirl.build(:event) }
      let!(:band) {FactoryGirl.build(:band)}
      let!(:user) {FactoryGirl.build(:user)}
      let!(:user_one) {FactoryGirl.build(:user)}
      let!(:owner) {FactoryGirl.build(:event_membership, role: 'owner', memberable_id: band.id, memberable_type: band.class_type, event: event)}
      let!(:admin) {FactoryGirl.build(:event_membership, role: 'admin', memberable_id: user.id, memberable_type: user.class_type, event: event)}
      let!(:performer) {FactoryGirl.build(:event_membership, role: 'performer', memberable: band, event: event)}
      let!(:event_application){ FactoryGirl.build(:event_application, event: event) }

      before :each do
        event.save && band.save && user.save
        owner.event_id = event.id
        owner.memberable = band
        owner.save
        admin.event_id = event.id
        admin.memberable = user
        admin.save
        performer.event_id = event.id
        performer.memberable = user_one
        admin.save
        event_application.event = event
        event_application.save
      end

      it 'should send notifications to the admins and owners' do
        expect(Notification.all.count).to eq 4
        expect(Notification.all.map(&:notifiable).uniq).to match_array [band, user]
      end

      it 'should not notify users that arent admins' do
        expect(Notification.all.count).to eq 4
        expect(Notification.all.map(&:notifiable).include?(performer)).to eq false
      end
    end
    # end class methods
  end

end
