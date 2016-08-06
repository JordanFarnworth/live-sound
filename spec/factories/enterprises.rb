FactoryGirl.define do
  factory :enterprise, class: Enterprise do
    id 12345
    name 'ent_name'
    description 'ent_description'
    social_media {}
    deleted_at nil
    address '123 Mulberry St'
    longitude 40.7608
    latitude 111.8910
    braintree_customer_id 67890
    youtube_link 'https://www.youtube.com/channel/youtube_id'
    email 'user@fake.com'
    genre 'ent_genre'
    phone_number '8015555555'
    settings {}
  end

  factory :invalid_enterprise, class: Enterprise do
    id nil
    name nil
    description nil
    social_media nil
    address nil
    longitude nil
    latitude nil
    braintree_customer_id nil
    youtube_link nil
    email nil
    genre nil
    phone_number nil
    settings nil
  end
end
