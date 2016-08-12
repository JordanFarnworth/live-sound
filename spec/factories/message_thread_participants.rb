FactoryGirl.define do
  factory :message_thread_participant do
    message_thread
    association :entity, factory: :user
  end
end
