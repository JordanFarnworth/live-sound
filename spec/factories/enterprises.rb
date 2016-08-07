FactoryGirl.define do
  factory :enterprise, class: Enterprise do
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
  end

  factory :invalid_enterprise, class: Enterprise do
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
  end
end
