class Notification < ApplicationRecord

  STATES = %w(new read deleted)

  belongs_to :notifiable, polymorphic: true
  belongs_to :contextable, polymorphic: true

  def self.build_notification(notifiable, contextable, action)
    Notification.create!(notifiable: notifiable, contextable: contextable, description: "#{contextable.class.to_s} number #{contextable.id} #{action}", state: 'new')
  end

end
