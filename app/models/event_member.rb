class EventMember < ApplicationRecord

  MEMBER_TYPES = %w(attendee owner performer)
  STATUSES = %w(active removed)

  belongs_to :event
  belongs_to :memberable, polymorphic: true

end
