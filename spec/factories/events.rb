FactoryGirl.define do
  factory :event, class: Event do
    recurrence_pattern "weekly"
    workflow_state 'active'
    price { (1..100).to_a.sample }
    title { Forgery::LoremIpsum.characters }
    description { Forgery::LoremIpsum.paragraph }
    address { Forgery::Address.street_address }
    longitude { Forgery::Geo.longitude }
    latitude { Forgery::Geo.latitude }
  end
end
