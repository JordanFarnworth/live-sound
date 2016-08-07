require 'rails_helper'

describe Event, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event)).to be_valid
  end

  let(:event){ FactoryGirl.build(:event) }

  it { should have_many(:bands).through(:event_members) }
  it { should have_many(:enterprises).through(:event_members) }
  it { should have_many(:private_parties).through(:event_members) }
  it { should have_many(:users).through(:event_members) }
  it { should have_many(:event_members) }
  it { should have_many(:notifications) }

end
