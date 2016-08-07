FactoryGirl.define do
  factory :event_member, class: EventMember do
    association :event, factory: :event
    association :memberable, factory: :private_party
    member_type 'performer'
    workflow_state 'active'
  end
end
