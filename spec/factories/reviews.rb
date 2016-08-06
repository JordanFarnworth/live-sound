FactoryGirl.define do
  factory :review do
    reviewable_type 'reviewable_type'
    reviewable_id 1234
    text 'review_text'
    rating 10
  end
end
