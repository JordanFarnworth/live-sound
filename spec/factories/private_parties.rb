FactoryGirl.define do
  factory :private_party, class: PrivateParty do
    name { Forgery::Name.company_name }
    description { Forgery::LoremIpsum.paragraph }
    social_media {}
    address { Forgery::Address.street_address }
    longitude { Forgery::Geo.longitude }
    latitude { Forgery::Geo.latitude }
    youtube_link { Forgery::Internet.domain_name }
    email { Forgery::Internet.email_address }
    phone_number { Forgery::Address.phone }
    settings {}
    workflow_state 'active'
  end

  factory :invalid_private_party, class: PrivateParty do
    name nil
    description nil
    social_media nil
    address nil
    longitude nil
    latitude nil
    youtube_link nil
    email nil
    phone_number nil
    settings nil
    workflow_state nil
  end
end
