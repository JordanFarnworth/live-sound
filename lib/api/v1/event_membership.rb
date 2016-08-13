module Api::V1::EventMembership
  include Api::V1::Json
  include Api::V1::Event

  def event_membership_json(event_membership, includes = [])
    attributes = %w(id event_id role workflow_state memberable_type memberable_id created_at)

    api_json(event_membership, only: attributes)
  end

  def event_memberships_json(event_memberships, includes = [])
    event_memberships.map { |e| event_membership_json e, includes }
  end
end
