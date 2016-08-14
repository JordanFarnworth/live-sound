require 'rails_helper'

describe Event, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event)).to be_valid
  end

  describe 'associations are valid' do
    let(:event){ FactoryGirl.build(:event) }
    it { should have_many(:bands).through(:event_members) }
    it { should have_many(:enterprises).through(:event_members) }
    it { should have_many(:private_parties).through(:event_members) }
    it { should have_many(:users).through(:event_members) }
    it { should have_many(:event_members) }
    it { should have_many(:event_invitations) }
    it { should have_many(:notifications) }
  end

  it 'all_members returns an array' do
    event = FactoryGirl.build(:event)
    expect(event.all_members).to be_an_instance_of(Array)
  end

  it '#active? should return true for a valid event' do
    event = FactoryGirl.build(:event)
    response = event.active?
    expect(response).to be true
  end
end
