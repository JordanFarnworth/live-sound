class MessageThreadParticipant < ApplicationRecord
  belongs_to :message_thread, inverse_of: :message_thread_participants
  belongs_to :entity, polymorphic: true

  validates :message_thread, presence: true
  validates :entity, presence: true
  validates :message_thread_id, uniqueness: { scope: [:entity_id, :entity_type] }
  validates :workflow_state, inclusion: { in: %w(unread read) }

  acts_as_paranoid

  scope :for_entity, -> (entity) { where(entity: entity) }

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'unread'
  end

  def mark_as_read
    update workflow_state: 'read'
    message_participants.update_all workflow_state: 'read'
  end

  def message_participants
    MessageParticipant.where(message_id: message_thread.messages, entity: entity)
  end

  def destroy
    transaction do
      message_participants.destroy_all
      super
    end
  end
end
