require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let!(:band) { create :band }
  let!(:user) { create :user }
  let!(:entity_user) { create :entity_user, user: user, userable: band }

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET #index' do
    let!(:review) { create :review, reviewerable: user, reviewable: band }

    it 'returns active reviews' do
      get :index, params: { band_id: band.id }
      expect(json_response['collection'].first['id']).to eql review.id
      review.update workflow_state: 'unpublished'
      get :index, params: { band_id: band.id }
      expect(json_response['collection']).to be_empty
    end
  end

  describe 'GET #show' do
    let!(:review) { create :review, reviewerable: user, reviewable: band }

    it 'returns active reviews' do
      get :show, params: { band_id: band.id, id: review.id }
      expect(json_response['id']).to eql review.id
      review.update workflow_state: 'unpublished'
      get :show, params: { band_id: band.id, id: review.id }
      expect(response.status).to eql 404
    end
  end

  describe 'POST #create' do
    let(:review_attributes) { attributes_for :review, reviewerable_id: user.id, reviewerable_type: user.class_type }

    it 'creates a review' do
      post :create, params: { band_id: band.id, review: review_attributes }
      expect(response.status).to eql 200
    end

    it 'does not allow a review to be created with an entity the user is not affiliated with' do
      bad_entity = create :band
      post :create, params: { band_id: band.id, review: review_attributes.merge({ reviewerable_id: bad_entity.id, reviewerable_type: bad_entity.class_type }) }
      expect(response.status).to eql 400
      expect(json_response['message']).to eql 'You cannot create a review as an entity with which you have no affiliation'
    end
  end

  describe 'DELETE #destroy' do
    let!(:review) { create :review, reviewerable: user, reviewable: band }

    it 'deletes a review' do
      delete :destroy, params: { band_id: band.id, id: review.id }
      expect(response.status).to eql 204
      expect { Review.find(review.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises unauthorized if user\'s entities did not create review' do
      user.entity_users.destroy_all
      delete :destroy, params: { band_id: band.id, id: review.id }
      expect(response.status).to eql 401
    end
  end

  describe 'PUT #update' do
    let!(:review) { create :review, reviewerable: user, reviewable: band }

    it 'updates a review' do
      put :update, params: { band_id: band.id, id: review.id, review: { rating: 5 } }
      expect(response.status).to eql 200
    end

    it 'raises unauthorized if user\'s entities did not create review' do
      user.entity_users.destroy_all
      put :update, params: { band_id: band.id, id: review.id, review: { rating: 5 } }
      expect(response.status).to eql 401
    end
  end
end
