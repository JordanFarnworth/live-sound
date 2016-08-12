require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:thread) { create :full_message_thread, messages_count: 1 }
  let(:thread_participant) { thread.message_thread_participants.first }
  let(:user) { thread_participant.entity }
  let(:entity_user) { user.entity_user_for_user(user) }
  let(:message) { thread.messages.first }

  before :each do
    request.headers['Authorization'] = "Bearer #{controller.create_jwt_session({ user_id: user.id })}"
  end

  describe 'GET #index' do
    it 'gets a list of message threads' do
      get :index, params: { user_id: user.id }
      json_thread = json_response['collection'].first
      expect(json_thread['id']).to eql thread.id
      expect(json_thread['subject']).to eql thread.subject
      expect(json_thread['entity_id']).to eql user.id
      expect(json_thread['entity_type']).to eql user.class_type
      expect(json_thread['workflow_state']).to eql 'unread'

      json_message = json_thread['messages'].first
      expect(json_message['id']).to eql message.id
      expect(json_message['body']).to eql message.body
      expect(json_message['workflow_state']).to_not be_nil
      expect(json_message['author_id']).to_not be_nil
      expect(json_message['author_type']).to_not be_nil
    end

    it 'requires a user be part of the specified entity' do
      entity_user.destroy
      get :index, params: { user_id: user.id }
      expect(response.status).to eql 401
    end
  end

  describe 'POST #create' do
    let(:message_params) do
      {
        message_thread_id: thread.id,
        recipients: [
          { id: user.id, type: user.class_type }
        ],
        subject: Forgery('lorem_ipsum').sentence,
        body: Forgery('lorem_ipsum').paragraph
      }
    end

    it 'returns a 404 if a message thread is specified but not valid' do
      message_params[:message_thread_id] += 1
      post :create, params: { user_id: user.id, message: message_params }
      expect(response.status).to eql 404
    end

    it 'adds a message to an existing thread' do
      post :create, params: { user_id: user.id, message: message_params }
      expect(response.status).to eql 200
      expect(thread.messages.count).to eql 2
      expect(json_response['messages'].map { |m| m['id'] }).to eql thread.messages.pluck(:id)
    end

    describe 'without an existing thread' do
      before :each do
        message_params.delete :message_thread_id
      end

      it 'creates a message thread' do
        post :create, params: { user_id: user.id, message: message_params }
        expect(response.status).to eql 200
        expect(MessageThread.count).to eql 2
        expect(json_response['entity_id']).to eql user.id
        expect(json_response['entity_type']).to eql user.class_type
      end

      it 'returns a 404 if any of the specified recipients are not valid' do
        message_params[:recipients].first[:id] += 100
        post :create, params: { user_id: user.id, message: message_params }
        expect(response.status).to eql 404
      end

      it 'returns an error if no valid recipients are supplied' do
        message_params.delete :recipients
        post :create, params: { user_id: user.id, message: message_params }
        expect(response.status).to eql 400
        expect(json_response['message']).to eql 'message[recipients] must include at least 1 valid recipient'
      end

      it 'requires a user to be part of the specified entity' do
        entity_user.destroy
        post :create, params: { user_id: user.id, message: message_params }
        expect(response.status).to eql 401
      end
    end
  end

  describe 'GET #show' do
    it 'shows a message thread' do
      get :index, params: { user_id: user.id, id: thread.id }
      expect(response.status).to eql 200
    end
  end

  describe 'POST #mark_as_read' do
    it 'marks a thread as read' do
      post :mark_as_read, params: { user_id: user.id, id: thread.id }
      expect(response.status).to eql 200
      expect(thread_participant.reload.workflow_state).to eql 'read'
      expect(thread_participant.message_participants.pluck(:workflow_state).uniq).to eql ['read']
    end
  end

  describe 'DELETE #remove_messages' do
    it 'deletes individual messages' do
      delete :remove_messages, params: { user_id: user.id, id: thread.id, remove: [message.id] }
      expect(response.status).to eql 204
      expect(thread_participant.message_participants.count).to eql 0
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a thread' do
      delete :destroy, params: { user_id: user.id, id: thread.id }
      expect(response.status).to eql 204
      expect(thread_participant.reload.deleted_at).to_not be_nil
    end
  end

end
