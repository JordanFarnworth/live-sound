class EventInvitation < ApplicationRecord

  STATES = %w(pending accepted declined deleted)
  STATUSES = %w(as_performer as_guest as_coowner)

  belongs_to :event
  belongs_to :invitable, polymorphic: true

end
