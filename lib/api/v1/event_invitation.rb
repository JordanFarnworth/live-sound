module Api::V1::EventInvitation
  include Api::V1::Json
  include Api::V1::Event

  def event_invitation_json(event_invitation, includes = [])
    attributes = %w(id event_id status workflow_state invitable_id invitable_type role)

    api_json(event_invitation, only: attributes).tap do |hash|
      hash['event'] = event_json(event_invitation.event) if includes.include?('with_events')
    end
  end

  def event_invitations_json(event_invitations, includes = [])
    event_invitations = event_invitations.includes(:event) if includes.include?('with_events')
    event_invitations.map { |e| event_invitation_json e, includes }
  end
end
