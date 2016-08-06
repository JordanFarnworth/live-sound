FactoryGirl.define do
  factory :event_application, class: EventApplication do
    id 12345
    event_id 'event_id'
    status 'event_status'
    state 'event_state'
    applicable_id 12345
    applicable_type 12345
  end
end
