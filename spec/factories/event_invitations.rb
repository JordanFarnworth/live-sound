FactoryGirl.define do
  factory :event_invitation, class: EventInvitation do
    id 12345
    event_id 'event_id'
    status 'event_status'
    state 'event_state'
    invitable_id 12345
    invitable_type 'invitable_type'
  end
end
