require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  let!(:band) { create :band }
  let!(:user) { create :user }
  let!(:entity_user) { create :entity_user, user: user, userable: band }
  let!(:favorite) { create :favorite, favoriterable: user, favoritable: band }

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET #index' do
    it 'returns a list of favorites given to an entity' do
      get :index, params: { band_id: band.id }
      expect(json_response['collection'].first['id']).to eql favorite.id
    end

    it 'does not allow a user who is not logged in to view favorites' do
      log_out user
      get :index, params: { band_id: band.id }
      expect(response.status).to eql 401
    end
  end

  describe 'GET #mine' do
    it 'returns a list of favorites given by an entity' do
      get :mine, params: { user_id: user }
      expect(json_response['collection'].first['id']).to eql favorite.id
    end

    it 'does not allow a user to view favorites given by entities with no affiliation' do
      user.entity_users.destroy_all
      get :mine, params: { user_id: user }
      expect(response.status).to eql 401
    end
  end

  describe 'POST #create' do
    it 'creates a favorite' do
      post :create, params: { band_id: band.id, favorite: { favoriterable_id: user.id, favoriterable_type: 'User' } }
      expect(response.status).to eql 200
      expect(json_response['id']).to eql favorite.id
    end

    it 'does not allow an entity to favorite themselves' do
      post :create, params: { user_id: user.id, favorite: { favoriterable_id: user.id, favoriterable_type: 'User' } }
      expect(response.status).to eql 400
      expect(json_response['message']).to eql 'You cannot favorite yourself'
    end

    it 'does nto allow an entity to create a favorite as an entity with which they have no affiliation' do
      user.entity_users.destroy_all
      post :create, params: { band_id: band.id, favorite: { favoriterable_id: user.id, favoriterable_type: 'User' } }
      expect(response.status).to eql 400
      expect(json_response['message']).to eql 'You cannot create a favorite as an entity with which you have no affiliation'
    end

    it 'responds gracefully if favoriterable cannot be determined' do
      post :create, params: { band_id: band.id, favorite: { favoriterable_id: user.id, favoriterable_type: 'Abcd' } }
      expect(response.status).to eql 400
      expect(json_response['favoriterable']).to eql ["can't be blank"]
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a favorite' do
      delete :destroy, params: { id: favorite.id }
      expect(response.status).to eql 204
      expect { Favorite.find(favorite.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'does not allow a user to delete a favorite created by an entity with which they have no affiliation' do
      user.entity_users.destroy_all
      delete :destroy, params: { id: favorite.id }
      expect(response.status).to eql 401
    end
  end
end
