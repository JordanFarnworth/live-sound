FactoryGirl.define do
  factory :event_member, class: EventMember do
    event_id 12345
    member_type 'member_type'
    status 'member_status'
    memberable_id 12345
    memberable_type 'memberable_type'
  end
end
