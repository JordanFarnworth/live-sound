class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :contextable, polymorphic: true
  
  WORKFLOW_STATES = %w(new read)
  CONTEXTABLES = %w(Event EventInvitation EventApplication Favorite Review EventMember)
  NOTIFIABLES = %w(Band Enterprise PrivateParty User)

  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true, inclusion: NOTIFIABLES
  validates :contextable_id, presence: true
  validates :contextable_type, presence: true, inclusion: CONTEXTABLES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  def self.build_notification(notifiable, contextable, action)
    Notification.create!(notifiable: notifiable, contextable: contextable, description: "#{contextable.class.to_s} number #{contextable.id} #{action}", state: 'new')
  end

end
