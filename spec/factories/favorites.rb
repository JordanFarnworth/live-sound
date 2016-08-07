FactoryGirl.define do
  factory :favorite do
    association :favoritable, factory: :band
    association :favoriterable, factory: :user
  end
end
