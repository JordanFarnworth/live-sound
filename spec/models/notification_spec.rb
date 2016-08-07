require 'rails_helper'

describe Notification, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:notification)).to be_valid
  end

  let(:notification){ FactoryGirl.build(:notification) }

  it { should belong_to(:notifiable) }
  it { should belong_to(:contextable) }

end
