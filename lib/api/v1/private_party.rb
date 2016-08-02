module Api::V1::PrivateParty
  include Api::V1::Json
  include Api::V1::User
  include Api::V1::Event
  include Api::V1::EventApplication
  include Api::V1::EventInvitation
  include Api::V1::Entities
  include Api::V1::Review
  include Api::V1::Notification

  def private_party_json(private_party, includes = [])
    attributes = %w(id name description email state address youtube_link phone_number)

    api_json(private_party, only: attributes).tap do |hash|
      includes = includes.flatten
      hash['users'] = users_json(private_party.users) if includes.include?('users')
      hash['type'] = private_party.class_type if includes.include?('type')
      hash['events'] = events_json(private_party.events_as_performer) if includes.include?('events_as_performer')
      hash['events'] = events_json(private_party.events_as_owner) if includes.include?('events_as_owner')
      hash['events'] = events_json(private_party.events_as_attendee) if includes.include?('events_as_attendee')
      hash['event_applications'] = event_applications_json(private_party.event_applications) if includes.include?('event_applitions')
      hash['event_applications'] = event_applications_json(private_party.event_applications, ['with_events']) if includes.include?('event_applitions_with_events')
      hash['event_invitations'] = event_invitations_json(private_party.event_invitations) if includes.include?('event_invitations')
      hash['event_invitations'] = event_invitations_json(private_party.event_invitations, ['with_events']) if includes.include?('event_invitations_with_events')
      hash['favorites'] = entities_json(private_party.favorite_entities) if includes.include?('favorites')
      hash['favorited_by'] = entities_json(private_party.favorited_by) if includes.include?('favorited_by')
      hash['reviews'] = reviews_json(private_party.reviews) if includes.include?('reviews')
      hash['reviews_with_reviewers'] = reviews_json(private_party.reviews, ['reviewer']) if includes.include?('reviews_with_reviewers')
      hash['reviews_given'] = reviews_json(private_party.reviews_given) if includes.include?('reviews_given')
      hash['reviews_given_with_reviewee'] = reviews_json(private_party.reviews_given, ['reviewee']) if includes.include?('reviews_given_with_reviewee')
      hash['notifications'] = notifications_json(private_party.notifications) if includes.include?('notifications')
      hash['new_notifications'] = notifications_json(private_party.notifications, ['new']) if includes.include?('new_notifications')
      hash['read_notifications'] = notifications_json(private_party.notifications, ['read']) if includes.include?('read_notifications')
    end
  end

  def private_parties_json(private_parties, includes = [])
    private_parties.map { |e| private_party_json e, includes }
  end
end
