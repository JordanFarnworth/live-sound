class EventMembership < ApplicationRecord
  belongs_to :event
  belongs_to :memberable, polymorphic: true

  WORKFLOW_STATES = %w(invited active pending declined)
  EVENT_ROLES = %w(owner admin performer attendee)

  acts_as_paranoid

  scope :as_owner, -> { where(role: 'owner') }
  scope :as_owner_or_admin, -> { where(role: %w(owner admin)) }
  scope :as_owner_or_performer, -> { where(role: %w(owner performer)) }
  scope :active, -> { where(workflow_state: 'active') }
  scope :invited, -> { where(workflow_state: 'invited') }
  scope :pending, -> { where(workflow_state: 'pending') }
  scope :declined, -> { where(workflow_state: 'declined') }

  after_create :send_create_notification
  after_update :send_update_notification
  after_destroy :send_destroy_notification

  validates :event_id, presence: true, uniqueness: { scope: [:memberable_id, :memberable_type, :role] }
  validates :memberable_id, presence: true
  validates :memberable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
  validates :role, presence: true, inclusion: EVENT_ROLES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active'
    self.role ||= 'attendee'
  end

  def invited?
    workflow_state == 'invited'
  end

  def notificaion(params = {})
    notification = Notification.where('notifications.created_at >= ?', 100.seconds.ago).where(params).first_or_initialize
  end

  def send_update_notification
    notificaion(notifiable: memberable, contextable: event).update_attributes!(action: "Your membership in event #{event.title} has been updated!", workflow_state: 'new')
  end

  def send_destroy_notification
    notificaion(notifiable: memberable, contextable: event).update_attributes!(action: "You have been removed from #{event.title}", workflow_state: 'new')
  end

  def send_create_notification
    if workflow_state == 'invited'
      Notification.build_notification!(memberable, event, "You have been invited to #{event.title}, as (an) #{role}")
      event.delay.send_notifications!("#{memberable.name} was invited to #{event.title} as a(n) #{role}", event.event_memberships.where.not(id: self.id))
    elsif workflow_state == 'active_member'
      Notification.build_notification!(memberable, event, "You have been added to #{event.title}, as (an) #{role}")
      event.delay.send_notifications!("#{memberable.name} was added to #{event.title} as a(n) #{role}", event.event_memberships.where.not(id: self.id).as_owner_or_admin)
    end
  end

end
