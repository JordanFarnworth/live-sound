class EventApplication < ApplicationRecord

  STATES = %w(pending accepted declined deleted)
  STATUSES = %w(as_performer)

  belongs_to :event
  belongs_to :applicable, polymorphic: true
end
