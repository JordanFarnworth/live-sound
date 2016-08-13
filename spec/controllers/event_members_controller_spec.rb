require 'rails_helper'

RSpec.describe EventMembersController, type: :controller do
  let!(:user) {FactoryGirl.create(:user)}

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET index' do
    let!(:band) {FactoryGirl.create(:band)}
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_member) {FactoryGirl.create(:event_member, event: event, memberable: band)}
    let!(:event_member_one) {FactoryGirl.create(:event_member, event: event, memberable: band, role: "owner")}

    it 'should render_json of @context\'s event_memberships' do
      get :index, params: { band_id: band.id }
      expect(assigns(:context)).to eql band
      expect(response.code).to eq "200"
      expect(json_response["collection"].length).to eq 2
      expect(json_response["collection"].map {|em| em["id"]}).to match_array [event_member.id, event_member_one.id]
    end
  end

  describe 'POST create' do
    let!(:event) {FactoryGirl.create(:event)}
    let(:user_entity) {FactoryGirl.create(:user_entity, user: user)}
    it 'should create a new event_membership' do
      post_params = {event_member: {workflow_state: 'active', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      post :create, post_params
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
    let!(:event_member) {FactoryGirl.create(:event_member, memberable: band, event: event, role: 'owner')}
    it 'should create a new event_membership' do
      put_params = {id: event_member.id, event_member: {workflow_state: 'active', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      put :update, params: put_params
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
    let!(:event_member) {FactoryGirl.create(:event_member, memberable: band, event: event, role: 'owner')}
    it 'should delete a event_membership' do
      delete_params = {id: event_member.id, event_id: event.id}
      expect(EventMember.all.count).to eq 1
      delete :destroy, params: delete_params
      expect(assigns(:event)).to eql event
      expect(EventMember.all.count).to eq 0
      expect(response.code).to eq "204"
    end
  end

end
