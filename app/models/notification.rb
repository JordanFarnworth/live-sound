class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :contextable, polymorphic: true

  WORKFLOW_STATES = %w(new read)
  CONTEXTABLES = %w(Event EventApplication Favorite Review EventMembership MessageThread)

  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :contextable_id, presence: true
  validates :contextable_type, presence: true, inclusion: CONTEXTABLES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  scope :read, -> {where(workflow_state: 'read')}
  scope :unread, -> {where(workflow_state: 'new')}

  def self.build_notification!(notifiable, contextable, action, workflow_state = "new")
    Notification.create!(notifiable: notifiable, contextable: contextable, action: action, description: "#{contextable.class.to_s} number #{contextable.id} #{action}", workflow_state: 'new')
  end

end
