class MessageThread < ApplicationRecord
  has_many :messages, dependent: :destroy, inverse_of: :message_thread
  has_many :message_thread_participants, dependent: :destroy, inverse_of: :message_thread

  validates :subject, presence: true

  acts_as_paranoid

  accepts_nested_attributes_for :messages
  accepts_nested_attributes_for :message_thread_participants

  def add_participant(entity)
    message_thread_participants.find_or_initialize_by(entity: entity)
  end
end
