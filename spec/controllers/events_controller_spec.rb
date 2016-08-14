require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:band) {FactoryGirl.create(:band)}
  let!(:user) {FactoryGirl.create(:user)}
  let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}

  before :each do
    Delayed::Worker.delay_jobs = false
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET index' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_one) {FactoryGirl.create(:event)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: 'owner')}
    let!(:event_membership_one) {FactoryGirl.create(:event_membership, event: event_one, memberable: band, role: 'performer')}
    it 'should get the context\'s events' do
      band.reload
      get :index, params: { band_id: band.id }
      expect(assigns(:context)).to eql band
      expect(response.code).to eql '200'
      expect(json_response['collection'].map {|event| event["id"]}).to match_array [event.id, event_one.id]
    end
  end

  describe 'GET show' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: 'owner')}

    it 'should get an event' do
      get :show, params: { event_id: event.id, id: event.id }
      expect(response.code).to eql '200'
      expect(json_response["id"]).to eql event.id
    end
  end

  describe 'PUT update' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: 'owner')}

    it 'should update the event' do
      put :update, params: {id: event.id, event: {title: "#{event.title} test"}}
      expect(response.code).to eql '200'
      expect(json_response["id"]).to eql event.id
      expect(json_response["title"]).to eql "#{event.title} test"
    end

    it 'should notifiy event_members of the update' do
      expect(Notification.all.count).to eq 0
      put :update, params: {id: event.id, event: {title: "#{event.title} test"}}
      event.send_notifications!("Event #{event.title} was updated to #{event.attributes}")
      expect(Notification.all.count).to eq 2
      expect(Notification.all.map(&:notifiable).include? band).to eq true
    end
  end

  describe 'DELETE destroy' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band, role: 'owner')}

    it 'should destroy the event' do
      delete :destroy, params: {id: event.id}
      expect(response.code).to eql '204'
    end

    it 'should notify members of the event of the deletion' do
      expect(Notification.all.count).to eq 0
      delete :destroy, params: {id: event.id}
      event.send_notifications!("Event #{event.title} was updated to #{event.attributes}")
      expect(Notification.all.count).to eq 2
      expect(Notification.all.map(&:notifiable_id).uniq).to match_array [band.id]
    end
  end

  describe 'POST create' do

    it 'should create an event' do
      post :create, params: {band_id: band.id, event: {title: "test event"}}
      expect(assigns(:context)).to eql band
      expect(response.code).to eql '200'
      expect(json_response["title"]).to eq "test event"
    end

    it 'should notify members of the event of the creation' do
      expect(Notification.all.count).to eq 0
      post :create, params: {band_id: band.id, event: {title: "test event"}}
      expect(Notification.all.count).to eq 1
      expect(Notification.all.first.contextable).to eq Event.first
      expect(Notification.all.first.notifiable).to eq band
    end
  end

end
