require 'rails_helper'

describe EventMembership, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:event_membership)).to be_valid
  end

  let(:event_membership){ FactoryGirl.build(:event_membership) }

  it { should belong_to(:event) }
  it { should belong_to(:memberable) }
end
