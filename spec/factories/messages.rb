FactoryGirl.define do
  factory :message do
    message_thread
    body { Forgery('lorem_ipsum').paragraph }
    association :author, factory: :user
  end
end
