class EventMember < ApplicationRecord

  MEMBER_TYPES = %w(attendee owner performer)
  STATUSES = %w(active removed)

  belongs_to :event
  belongs_to :memberable, polymorphic: true

  scope :as_owner, -> { where(member_type: 'owner') }
  scope :as_owner_or_performer, -> { where(member_type: %w(owner performer)) }

end
