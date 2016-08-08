require 'rails_helper'

describe Favorite, type: :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:favorite)).to be_valid
  end

  let(:favorite) { FactoryGirl.build(:favorite) }

  it { should belong_to(:favoritable) }
  it { should belong_to(:favoriterable) }

  it 'builds a favorite' do
    built_favorite = Favorite.build_favorite create(:band), create(:user)
    expect(built_favorite).to be_valid
  end

  it 'retrieves an existing favorite between entities if exists' do
    built_favorite = Favorite.build_favorite favorite.favoritable, favorite.favoriterable
    expect(built_favorite.id).to eql favorite.id
  end
end
