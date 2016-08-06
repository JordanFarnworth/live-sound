module Api::V1::EventMember
  include Api::V1::Json
  include Api::V1::Event

  def event_member_json(event_member, includes = [])
    attributes = %w(id event_id member_type workflow_state memberable_type memberable_id created_at)

    api_json(event_member, only: attributes)
  end

  def event_members_json(event_members, includes = [])
    event_members.map { |e| event_member_json e, includes }
  end
end
