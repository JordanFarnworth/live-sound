FactoryGirl.define do
  factory :user do
    username { Forgery::Internet.user_name }
    password { SecureRandom.hex }
    workflow_state 'active'
  end
end
