require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let!(:user) { create :user }

  it 'creates a jwt session' do
    expect(controller.create_jwt_session(user_id: user.id)).to_not be_nil
    expect(controller.instance_variable_get(:@jwt_session)).to_not be_nil
  end

  describe '#jwt_session' do
    let!(:jwt_session) { controller.create_jwt_session(user_id: user.id) }

    before :each do
      controller.instance_variable_set :@jwt_session, nil
    end

    it 'uses an access token in an authorization header' do
      request.headers['Authorization'] = "Bearer #{jwt_session}"
      expect(controller.jwt_session[:user_id]).to eql user.id
    end

    it 'uses an access token in params' do
      controller.params[:access_token] = jwt_session
      expect(controller.jwt_session[:user_id]).to eql user.id
    end

    it 'uses an access token in a cookie' do
      request.cookies[:access_token] = jwt_session
      expect(controller.jwt_session[:user_id]).to eql user.id
    end

    it 'raises an error if a token is tampered with' do
      request.headers['Authorization'] = "Bearer #{jwt_session[0...-2]}"
      expect { controller.jwt_session }.to raise_error(JWT::VerificationError)
    end

    it 'raises an error if a token has been revoked' do
      JwtSession.destroy_all
      request.headers['Authorization'] = "Bearer #{jwt_session}"
      expect { controller.jwt_session }.to raise_error(JWT::InvalidJtiError)
    end
  end
end
