class EventApplication < ApplicationRecord
  belongs_to :event
  belongs_to :applicable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)
  APPLICATION_TYPES = %w(performer volunteer)
  APPLICABLE_TYPES = %w(Band User) # for now

  validates :event_id, presence: true, uniqueness: { scope: [:applicable_id, :applicable_type] }
  validates :applicable_id, presence: true
  validates :applicable_type, presence: true, inclusion: APPLICABLE_TYPES
  validates :application_type, presence: true, inclusion: APPLICATION_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  after_create :send_create_notifications
  after_update :send_update_notifications
  before_destroy :send_destroy_notifications
  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'pending'
  end

  def send_create_notifications
    self.delay.send_notifications!("#{applicable.name} has applied to be a member of #{event.title} as a #{application_type}")
  end

  def send_update_notifications
    self.delay.send_notifications!("Application #{id} for event #{event.title} has been updated.")
  end

  def send_destroy_notifications
    self.delay.send_notifications!("Application #{id} for event #{event.title} has been deleted.")
  end

  def send_notifications!(action, members = event.event_memberships.as_owner_or_admin.map(&:memberable))
    members.each do |member|
      Notification.build_notification!(member, event, action)
    end
  end


end
