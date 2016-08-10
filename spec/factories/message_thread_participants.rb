FactoryGirl.define do
  factory :message_thread_participant do
    message_thread nil
    entity_id 1
    entity_type "MyString"
    workflow_state "MyString"
    deleted_at "2016-08-10 13:26:01"
  end
end
