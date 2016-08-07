FactoryGirl.define do
  factory :review, class: Review do
    association :reviewerable, factory: :user
    association :reviewable, factory: :band
    text { Forgery::LoremIpsum.paragraph }
    workflow_state 'active'
    rating { (1..5).to_a.sample }
  end
end
