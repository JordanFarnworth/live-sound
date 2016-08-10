FactoryGirl.define do
  factory :message do
    message_thread nil
    body "MyText"
    author_id 1
    author_type "MyString"
    deleted_at "2016-08-10 13:30:22"
  end
end
