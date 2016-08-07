FactoryGirl.define do
  factory :band, class: Band do
    name { Forgery::Name.company_name }
    description { Forgery::LoremIpsum.paragraph }
    social_media {}
    address { Forgery::Address.street_address }
    longitude { Forgery::Geo.longitude }
    latitude { Forgery::Geo.latitude }
    youtube_link { Forgery::Internet.domain_name }
    email { Forgery::Internet.email_address }
    genre 'rock'
    phone_number { Forgery::Address.phone }
    workflow_state 'active'
    settings {}
  end

  factory :invalid_band, class: Band do
    name nil
    description nil
    social_media nil
    address nil
    longitude nil
    latitude nil
    youtube_link nil
    email nil
    genre nil
    phone_number nil
    workflow_state nil
    settings nil
  end
end
