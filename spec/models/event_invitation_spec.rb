require 'rails_helper'

describe EventInvitation, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event_invitation)).to be_valid
  end

  let(:event_invitation){ FactoryGirl.build(:event_invitation) }

  it { should belong_to(:event) }
  it { should belong_to(:invitable) }
end
