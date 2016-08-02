class ApiKey < ApplicationRecord
  belongs_to :user

  validates_presence_of :key
  validates_presence_of :key_hint
  validates_presence_of :user_id

  before_validation :infer_values

  def infer_values
    expires_at ||= 5.years.from_now
    key_hint ||= key[0, 6]
    key = SecurityHelper.sha_hash(key) if key_changed?
  end

  def destroy
    expires_at = Time.now
    save
  end

  def expired?
    expires_at < Time.now
  end

end
