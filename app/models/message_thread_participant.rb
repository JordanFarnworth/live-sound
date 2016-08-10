class MessageThreadParticipant < ApplicationRecord
  belongs_to :message_thread, inverse_of: :message_thread_participants
  belongs_to :entity, polymorphic: true

  validates :message_thread, presence: true
  validates :entity, presence: true
  validates :message_thread_id, uniqueness: { scope: [:entity_id, :entity_type] }

  acts_as_paranoid
end
