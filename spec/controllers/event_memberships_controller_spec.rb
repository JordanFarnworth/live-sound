require 'rails_helper'

RSpec.describe EventMembershipsController, type: :controller do
  let!(:user) {FactoryGirl.create(:user)}

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET index' do
    let!(:band) {FactoryGirl.create(:band)}
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band)}
    let!(:event_membership_one) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: "owner")}

    it 'should render_json of @context\'s event_memberships' do
      get :index, params: { band_id: band.id }
      expect(assigns(:context)).to eql band
      expect(response.code).to eq "200"
      expect(json_response["collection"].length).to eq 2
      expect(json_response["collection"].map {|em| em["id"]}).to match_array [event_membership.id, event_membership_one.id]
    end
  end

  describe 'POST create' do
    let!(:event) {FactoryGirl.create(:event)}
    let(:user_entity) {FactoryGirl.create(:user_entity, user: user)}
    it 'should create a new event_membership' do
      post :create, params: {event_membership: {workflow_state: 'active_member', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(response.status).to eq 200
      expect(json_response["event_id"]).to eq event.id
      expect(json_response["memberable_id"]).to eq user.id
    end
  end

  describe 'PUT update' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:band) {FactoryGirl.create(:band)}
    let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, memberable: band, event: event, role: 'owner')}
    it 'should create a new event_membership' do
      put :update, params: {id: event_membership.id, event_membership: {workflow_state: 'active_member', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(response.status).to eq 200
      expect(json_response["event_id"]).to eq event.id
      expect(json_response["memberable_id"]).to eq band.id
      expect(json_response["role"]).to eq "admin"
    end
  end

  describe 'DELETE #destroy' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:band) {FactoryGirl.create(:band)}
    let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, memberable: band, event: event, role: 'owner')}
    it 'should delete a event_membership' do
      expect(EventMembership.all.count).to eq 1
      delete :destroy, params: {id: event_membership.id, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(EventMembership.all.count).to eq 0
      expect(response.code).to eq "204"
    end
  end

end
