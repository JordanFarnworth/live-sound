require 'rails_helper'

RSpec.describe EventApplicationsController, type: :controller do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:band) {FactoryGirl.create(:band)}
  let!(:other_band) {FactoryGirl.create(:band)}
  let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}
  let!(:applicant) {FactoryGirl.create(:user)}
  let!(:event) {FactoryGirl.create(:event)}
  let!(:owner) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: "owner")}
  let!(:event_application){ FactoryGirl.create(:event_application, event: event, applicable: applicant) }

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
    Notification.destroy_all
  end

  describe 'GET index' do

    it 'should render_json of @context\'s event_applications' do
      get :index, params: { event_id: event.id }
      expect(assigns(:context)).to eql event
      expect(response.code).to eq "200"
      expect(json_response["collection"].length).to eq 1
      expect(json_response["collection"].map {|em| em["id"]}).to match_array [event_application.id]
    end
  end

  describe 'POST create' do
    it 'should allow an application to be created for an event' do
      expect(Notification.all.length).to eq 0
      EventApplication.destroy_all
      post :create, params: {event_application: {event_id: event.id, applicable_type: applicant.class_type, applicable_id: applicant.id, application_type: 'performer'}, event_id: event.id}
      expect(assigns(:context)).to eql event
      expect(response.code).to eq "200"
      expect(json_response["id"]).to eq EventApplication.last.id
      expect(json_response["event_id"]).to eq event.id
      expect(Notification.all.length).to eq 2
    end
  end

  describe 'PUT update' do
    it 'should update an event_application to accepted' do
      expect(Notification.all.length).to eq 0
      put :update, params: {event_application: {workflow_state: 'accepted', event_id: event.id}, event_id: event.id, id: event_application.id}
      expect(assigns(:context)).to eql event
      expect(response.code).to eq "200"
      expect(json_response["id"]).to eq event_application.id
      expect(json_response["event_id"]).to eq event.id
      expect(Notification.all.length).to eq 1
    end
  end

  describe 'DELETE destroy' do
    it 'should delete the event_application' do
      expect(Notification.all.length).to eq 0
      delete :destroy, params: {id: event_application.id, event_id: event.id}
      expect(assigns(:context)).to eql event
      expect(response.code).to eq "204"
      expect(Notification.all.length).to eq 1
    end
  end



end
