class MessageParticipant < ApplicationRecord
  belongs_to :message
  belongs_to :entity, polymorphic: true

  validates :message, presence: true
  validates :entity, presence: true
  validates :workflow_state, inclusion: { in: %w(unread read) }
  validates :message_id, uniqueness: { scope: [:entity_id, :entity_type] }

  acts_as_paranoid

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'unread'
  end
end
