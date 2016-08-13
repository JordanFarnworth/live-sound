FactoryGirl.define do
  factory :event_membership, class: EventMembership do
    association :event, factory: :event
    association :memberable, factory: :band
    role 'performer'
    workflow_state 'active_member'
    status 'accepted'
  end
end
