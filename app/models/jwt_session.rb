class JwtSession < ApplicationRecord
  belongs_to :user

  before_validation do
    self.jwt_id ||= SecureRandom.uuid
  end
end
