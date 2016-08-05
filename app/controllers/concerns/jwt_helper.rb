module JwtHelper
  extend ActiveSupport::Concern

  included do
    def jwt_session
      unless @jwt_session
        if request.headers['Authorization'] && request.headers['Authorization'].match(/Bearer (.+)/)
          token = request.headers['Authorization'].match(/Bearer (.+)/)[1]
        end
        token ||= params[:access_token]
        token ||= cookies[:access_token]
        return {} if token.blank?

        decoded = JWT.decode token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256', verify_jti: proc { |jwt_id| JwtSession.where(jwt_id: jwt_id).exists? } }
        @jwt_session = decoded.first.delete('data').with_indifferent_access
        @jwt_opts = decoded.first.with_indifferent_access
      end
      @jwt_session
    end

    def create_jwt_session(opts = {})
      @jwt_session = opts.with_indifferent_access

      payload = { data: opts, jti: JwtSession.create(user_id: opts[:user_id]).jwt_id }
      JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
    end
  end
end
