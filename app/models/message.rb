class Message < ApplicationRecord
  belongs_to :message_thread, inverse_of: :messages
  belongs_to :author, polymorphic: true
  has_many :message_participants, dependent: :destroy

  validates :message_thread, presence: true
  validates :body, presence: true
  validates :author, presence: true

  acts_as_paranoid

  after_save :populate_participants_from_thread

  def add_participant(entity)
    message_participants.find_or_create_by(entity: entity)
  end

  def populate_participants_from_thread
    thread_participants = message_thread.message_thread_participants
    thread_participants.each do |thread_participant|
      participant = add_participant(thread_participant.entity)
      participant.update(workflow_state: 'read') if thread_participant.entity == author
    end
  end
end
