FactoryGirl.define do
  factory :message_participant do
    message
    association :entity, factory: :user
  end
end
