FactoryGirl.define do
  factory :event, class: Event do
    id 1234
    recurrence_pattern "weekly"
    state "state"
    price 1
    title "event_title"
    description "event_description"
    status "event_status"
    address "877 Sesame Street"
    longitude 40.7608
    latitude 111.8910
  end
end
