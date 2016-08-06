module Api::V1::EntityUser
  include Api::V1::Json
  include Api::V1::Event

  def entity_user_json(entity_user, includes = [])
    attributes = %w(id user_id userable_id userable_type workflow_state)

    api_json(entity_user, only: attributes).tap do |hash|
      hash['event'] = event_json(entity_user.event) if includes.include?('with_events')
    end
  end

  def entity_users_json(entity_users, includes = [])
    entity_users = entity_users.includes(:event) if includes.include?('with_events')
    entity_users.map { |e| entity_user_json e, includes }
  end
end
