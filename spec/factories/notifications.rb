FactoryGirl.define do
  factory :notification, class: Notification do
    id 12345
    notifiable_id 'notifiable_id'
    notifiable_type 'notifiable_type'
    contextable_id 12345
    contextable_type 'contextable_type'
    description 'description'
    state ''
  end
end
