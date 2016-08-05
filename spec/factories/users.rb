FactoryGirl.define do
  factory :user do
    username { Forgery::Internet.user_name }
    password { SecureRandom.hex }
    state 'active'
  end
end
