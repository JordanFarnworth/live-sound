FactoryGirl.define do
  factory :event_invitation, class: EventInvitation do
    association :event, factory: :event
    association :invitable, factory: :band
    invitation_type 'as_performer'
    workflow_state 'pending'
  end
end
