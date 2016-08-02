module Api::V1::Entities

  def entity_json(entity, includes = [])
    case entity.class.to_s
    when "User"
      user_json(entity, includes)
    when "Enterprise"
      enterprise_json(entity, includes)
    when "PrivateParty"
      private_party_json(entity, includes)
    when "Band"
      band_json(entity, includes)
    end
  end

  def entities_json(enitites, includes = [])
    enitites.map { |e| entity_json e, includes }
  end
end
