FactoryGirl.define do
  factory :notification, class: Notification do
    association :notifiable, factory: :user
    association :contextable, factory: :event_application
    description { Forgery::LoremIpsum.paragraph }
    workflow_state 'new'
  end
end
