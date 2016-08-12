FactoryGirl.define do
  factory :message_thread do
    subject { Forgery('lorem_ipsum').sentence }
  end

  factory :full_message_thread, parent: :message_thread do
    transient do
      recipients_count 5
      messages_count 5
    end

    after(:create) do |message_thread, evaluator|
      create_list(:message_thread_participant, evaluator.recipients_count, message_thread: message_thread)
      evaluator.messages_count.times do
        create(:message, message_thread: message_thread, author: message_thread.message_thread_participants.sample.entity)
      end
    end
  end
end
