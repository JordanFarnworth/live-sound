class User < ApplicationRecord
  include Entityable

  acts_as_paranoid
  has_secure_password
  validates_uniqueness_of :uid, allow_nil: true
  validates_inclusion_of :state, in: %w(pending_approval active)
  validates_format_of :email, with: PatternHelper::EMAIL_PATTERN, unless: :email_blank?

  scope :pending, -> { where(state: :pending_approval) }

  after_create :create_default_entity_user

  serialize :settings, Hash

  def entities
    EntityUser.where(user: self).includes(:userable).map(&:userable)
  end

  def email_blank?
    self.email.nil?
  end

  def bypass_password_save!
    errors = self.errors.full_messages
    if errors.first == "Password can't be blank" && errors.length == 1
      self.save validate: false
    end
  end

  def only_password_error?
    errors = self.errors.full_messages
    errors.first == "Password can't be blank" && errors.length == 1
  end

  def create_default_entity_user
    EntityUser.find_or_create_by(user_id: self.id, userable: self)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.display_name = auth.name
      user.username = auth.name
      user.facebook_image_url = auth.image
      user.oauth_token = auth.token
      user.oauth_expires_at = Time.at(auth.oauth_expires_at)
      user.state = 'active'
      user.save! validate: false
    end
  end
end
