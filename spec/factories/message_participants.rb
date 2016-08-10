FactoryGirl.define do
  factory :message_participant do
    message nil
    entity_id 1
    entity_type "MyString"
    workflow_state "MyString"
    deleted_at "2016-08-10 13:31:05"
  end
end
