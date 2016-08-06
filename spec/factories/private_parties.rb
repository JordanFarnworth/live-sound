FactoryGirl.define do
  factory :private_party, class: PrivateParty do
    id 12345
    name 'party_name'
    description 'party_description'
    social_media {}
    address '123 Mulberry St'
    longitude 40.7608
    latitude 111.8910
    braintree_customer_id 67890
    youtube_link 'https://www.youtube.com/channel/youtube_id'
    email 'user@fake.com'
    phone_number '8015555555'
    settings {}
    state 'active'
  end

  factory :invalid_private_party, class: PrivateParty do
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
    phone_number nil
    settings nil
    state nil
  end
end
