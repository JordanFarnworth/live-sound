require 'rails_helper'

RSpec.describe JwtSession, type: :model do
  it 'generates a unique id' do
    jwt = JwtSession.new
    jwt.save
    expect(jwt.jwt_id).to_not be_nil
  end

  let(:jwt_session){ FactoryGirl.build(:jwt_session) }

  it { should belong_to(:user) }
end
