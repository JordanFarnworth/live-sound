module Api::V1::PrivateParty
  include Api::V1::Json

  def private_party_json(private_party, includes = [])
    attributes = %w(id name description email state address youtube_link phone_number)

    api_json(private_party, only: attributes, methods: %w(class_type))
  end

  def private_parties_json(private_parties, includes = [])
    private_parties.map { |e| private_party_json e, includes }
  end
end
