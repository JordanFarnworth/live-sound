FactoryGirl.define do
  factory :event_application, class: EventApplication do
    association :event, factory: :event
    association :applicable, factory: :band
    workflow_state 'pending'
    application_type 'as_performer'
  end
end
