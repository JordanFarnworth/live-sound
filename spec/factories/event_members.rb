FactoryGirl.define do
  factory :event_member, class: EventMember do
    association :event, factory: :event
    association :memberable, factory: :band
    role 'performer'
    workflow_state 'active'
  end
end
