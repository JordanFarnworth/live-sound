FactoryGirl.define do
  factory :jwt_session do
    username { Forgery::Internet.user_name }
    password { SecureRandom.hex }
  end
end
