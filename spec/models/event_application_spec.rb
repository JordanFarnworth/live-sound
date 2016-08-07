require 'rails_helper'

describe EventApplication, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:event_application)).to be_valid
  end

  let(:event_application){ FactoryGirl.build(:event_application) }

  it { should belong_to(:event) }
  it { should belong_to(:applicable) }
end
