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
      expect(json_response["collection"].map {|em| em['workflow_state']}.uniq).to match_array ['active']
    end
  end

  describe 'POST create' do
    let!(:band) {FactoryGirl.create(:band)}
    let!(:event) {FactoryGirl.create(:event)}
    let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, event: event, memberable: band)}

    it 'should create a notification for the users in the event when another user is added.' do
      expect(Notification.all.count).to eq 1
      post :create, params: {event_membership: {workflow_state: 'active_member', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(Notification.all.count).to eq 2
      expect(Notification.all.map &:notifiable).to match_array [band, user]
      expect(Notification.all.map(&:contextable).uniq).to eq [event]
    end

    it 'should create a notification for an invitation' do
      expect(Notification.all.count).to eq 1
      post :create, params: {event_membership: {workflow_state: 'invited', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(Notification.all.first.notifiable).to eq band
    end

    it 'should create a new event_membership' do
      post :create, params: {event_membership: {workflow_state: 'active', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(response.status).to eq 200
      expect(json_response["event_id"]).to eq event.id
      expect(json_response["memberable_id"]).to eq user.id
      expect(json_response["memberable_id"]).to eq user.id
      expect(json_response["workflow_state"]).to eq "active"
    end

    it 'allows a user to invite themselves to a publicly accessible event' do
      post :create, params: { event_membership: { workflow_state: 'invited', role: 'admin', memberable_type: 'User', memberable_id: user.id }, event_id: event.id }
      membership = assigns(:event_membership)
      expect(response.status).to eql 200
      expect(membership.workflow_state).to eql 'active'
      expect(membership.role).to eql 'attendee'
      expect(membership.memberable).to eql user
      expect(membership.event).to eql event

      EventMembership.delete_all
      event.update workflow_state: 'unpublished'
      post :create, params: { event_membership: { workflow_state: 'active', role: 'attendee', memberable_type: 'User', memberable_id: user.id }, event_id: event.id }
      expect(response.status).to eql 404
    end

    describe 'involving other entities' do
      let!(:invited_user) { FactoryGirl.create(:user) }

      it 'allows an attendee of a public event to invite other entities' do
        event.add_member user, 'attendee'
        post :create, params: { event_membership: { workflow_state: 'active', role: 'admin', memberable_type: 'User', memberable_id: invited_user.id }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(response.status).to eql 200
        expect(membership.workflow_state).to eql 'invited'
        expect(membership.memberable).to eql invited_user
        expect(membership.event).to eql event
        expect(membership.role).to eql 'attendee'
      end

      it 'does not allow an attendee to invite entities to a private event' do
        event.unpublish!
        event.add_member user, 'attendee'
        post :create, params: { event_membership: { workflow_state: 'active', role: 'admin', memberable_type: 'User', memberable_id: invited_user.id }, event_id: event.id }
        expect(response.status).to eql 401
      end

      it 'does not allow an event membership to be created with a role of owner' do
        event.add_member user, 'owner'
        post :create, params: { event_membership: { workflow_state: 'active', role: 'owner', memberable_type: 'User', memberable_id: invited_user.id }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(response.status).to eql 200
        expect(membership.role).to eql 'admin'
      end

      it 'allows an owner or admin to invite entities to a private event' do
        event.unpublish!
        event.add_member user, 'owner'
        post :create, params: { event_membership: { workflow_state: 'active', role: 'attendee', memberable_type: 'User', memberable_id: invited_user.id }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(response.status).to eql 200
        expect(membership.workflow_state).to eql 'invited'
        expect(membership.role).to eql 'attendee'

        EventMembership.delete_all
        event.add_member user, 'admin'
        post :create, params: { event_membership: { workflow_state: 'active', role: 'attendee', memberable_type: 'User', memberable_id: invited_user.id }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(response.status).to eql 200
        expect(membership.workflow_state).to eql 'invited'
        expect(membership.role).to eql 'attendee'
      end
    end

  end

  describe 'PUT update' do
    let!(:event) { FactoryGirl.create(:event) }
    let!(:band) { FactoryGirl.create(:band) }
    let!(:entity_user) { FactoryGirl.create(:entity_user, user: user, userable: band) }
    let!(:event_membership) { FactoryGirl.create(:event_membership, memberable: band, event: event, role: 'owner') }

    it 'should update an event_membership' do
      put :update, params: {id: event_membership.id, event_membership: {workflow_state: 'active', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(response.status).to eq 200
      expect(json_response["event_id"]).to eq event.id
      expect(json_response["memberable_id"]).to eq band.id
      expect(json_response["role"]).to eq "admin"
      expect(json_response["workflow_state"]).to eq "active"
    end

    it 'allows an entity to accept their own invited membership' do
      event_membership.update workflow_state: 'invited'
      put :update, params: { id: event_membership.id, event_membership: { workflow_state: 'active' }, event_id: event.id }
      membership = assigns(:event_membership)
      expect(response.status).to eql 200
      expect(membership.workflow_state).to eql 'active'
    end

    describe 'involving other entities' do
      let!(:invited_user) { create :user }
      let!(:invitation) { create :event_membership, memberable: invited_user, event: event, role: 'attendee', workflow_state: 'invited' }

      it 'does not allow an admin or owner to accept an invitation on another entity\'s behalf' do
        put :update, params: { id: invitation.id, event_membership: { workflow_state: 'active' }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(membership.workflow_state).to eql 'invited'
      end

      it 'does not allow an attendee to change their role' do
        log_in invited_user
        put :update, params: { id: invitation.id, event_membership: { role: 'admin' }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(membership.role).to eql 'attendee'
      end

      it 'allows an admin or owner to decline a membership' do
        put :update, params: { id: invitation.id, event_membership: { workflow_state: 'declined' }, event_id: event.id }
        membership = assigns(:event_membership)
        expect(membership.workflow_state).to eql 'declined'
      end

      it 'allows an admin or owner to change the role of a membership' do
        put :update, params: { id: invitation.id, event_membership: { role: 'performer' }, event_id: event.id }
        expect(invitation.reload.role).to eql 'performer'
      end
    end

    it 'should create a notification for an invitation' do
      expect(Notification.all.count).to eq 1
      post :create, params: {event_membership: {workflow_state: 'invitation', status: 'pending', role: 'admin', event_id: event.id, memberable_type: "User", memberable_id: user.id}, event_id: event.id}
      expect(Notification.all.count).to eq 1
      expect(Notification.all.first.notifiable).to eq band
    end
  end

  describe 'DELETE #destroy' do
    let!(:event) {FactoryGirl.create(:event)}
    let!(:band) {FactoryGirl.create(:band)}
    let!(:entity_user) {FactoryGirl.create(:entity_user, user: user, userable: band)}
    let!(:event_membership) {FactoryGirl.create(:event_membership, memberable: band, event: event, role: 'admin')}
    it 'should delete a event_membership' do
      expect(EventMembership.all.count).to eq 1
      delete :destroy, params: {id: event_membership.id, event_id: event.id}
      expect(assigns(:event)).to eql event
      expect(EventMembership.all.count).to eq 0
      expect(response.code).to eq "204"
    end

    it 'does not allow an owner membership to be deleted' do
      event_membership.update role: 'owner'
      delete :destroy, params: { id: event_membership.id }
      expect(response.status).to eql 401
    end

    it 'allows an attendee to delete their own membership' do
      event_membership.update role: 'attendee'
      delete :destroy, params: { id: event_membership.id }
      expect(response.status).to eql 204
      expect { EventMembership.find(event_membership.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe 'involving other entities' do
      let!(:invited_user) { create :user }
      let!(:invitation) { create :event_membership, memberable: invited_user, event: event, role: 'attendee', workflow_state: 'active' }

      it 'allows an owner or admin to delete memberships for other entities' do
        delete :destroy, params: { id: invitation.id }
        expect(response.status).to eql 204
        expect { EventMembership.find(invitation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'does not allow an attendee or performer to delete memberships for other entities' do
        event_membership.update role: 'attendee'
        delete :destroy, params: { id: invitation.id }
        expect(response.status).to eql 401
      end
    end
  end

end
