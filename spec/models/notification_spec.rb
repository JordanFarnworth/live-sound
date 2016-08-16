require 'rails_helper'

describe Notification, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:notification)).to be_valid
  end

  let(:notification){ FactoryGirl.build(:notification) }

  it { should belong_to(:notifiable) }
  it { should belong_to(:contextable) }

  describe 'scopes' do
    let!(:read_notification){ FactoryGirl.build(:notification, workflow_state: 'read') }
    let!(:unread_notification){ FactoryGirl.build(:notification, workflow_state: 'new') }
    it 'should return read notifications' do
      read_notification.save
      expect(Notification.read.first).to eq read_notification
    end
    it 'should return new notifications' do
      unread_notification.save
      expect(Notification.unread.first).to eq unread_notification
    end
  end

  describe 'class methods' do
    describe '#self.build_notification!' do
      let(:user) {FactoryGirl.create(:user)}
      let(:event) {FactoryGirl.create(:event)}
      it 'should build a notification' do
        Notification.build_notification!(user, event, "#{event.title} updated")
        expect(Notification.all.count).to eq 1
        expect(Notification.all.first.notifiable).to eq user
        expect(Notification.all.first.contextable).to eq event
        expect(Notification.all.first.action).to eq "#{event.title} updated"
      end
    end
  end

end
