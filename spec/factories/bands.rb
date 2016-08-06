FactoryGirl.define do
  factory :band, class: Band do
    id 12345
    name 'band_name'
    description 'band_description'
    social_media {}
    address '123 Mulberry St'
    longitude 40.7608
    latitude 111.8910
    braintree_customer_id 67890
    youtube_link 'https://www.youtube.com/channel/youtube_id'
    email 'user@fake.com'
    genre nil
    phone_number '8015555555'
    state 'active'
    settings {}
  end

  factory :invalid_band, class: Band do
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
    state nil
    settings nil
  end
end
