require 'rails_helper'

describe EventMember, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:event_member)).to be_valid
  end

  let(:event_member){ FactoryGirl.build(:event_member) }

  it { should belong_to(:event) }
  it { should belong_to(:memberable) }
end
