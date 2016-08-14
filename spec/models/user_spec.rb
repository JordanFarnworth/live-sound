require 'rails_helper'

  RSpec.describe User, type: :model do

    describe 'class methods' do
      let!(:user) {FactoryGirl.create(:user, display_name: "test name")}

      it 'should return the users display name' do
        expect(user.name).to eq user.display_name
      end
    end
    
  end
