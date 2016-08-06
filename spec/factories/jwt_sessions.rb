FactoryGirl.define do
  factory :jwt_session, class: JwtSession do
    id 'jwt_id'
    user_id 5678
    jwt_id ''
  end
end
