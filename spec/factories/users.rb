FactoryGirl.define do
  factory :user, class: User do
    username { Forgery::Internet.user_name }
    email { Forgery::Internet.email_address}
    password { SecureRandom.hex }
    workflow_state 'active'
  end
end
