module Api::V1::Band
  include Api::V1::Json
  include Api::V1::Event

  def band_json(band, includes = [])
    attributes = %w(id name description email state address youtube_link genre phone_number)

    api_json(band, only: attributes).tap do |hash|
      includes = includes.flatten
      hash['users'] = users_json(band.users) if includes.include?('users')
      hash['type'] = band.class_type if includes.include?('type')
      hash['events'] = events_json(band.events_as_performer) if includes.include?('events_as_performer')
      hash['events'] = events_json(band.events_as_owner) if includes.include?('events_as_owner')
      hash['events'] = events_json(band.events_as_attendee) if includes.include?('events_as_attendee')
      hash['event_applications'] = event_applications_json(band.event_applications) if includes.include?('event_applitions')
      hash['event_applications'] = event_applications_json(band.event_applications, ['with_events']) if includes.include?('event_applitions_with_events')
      hash['event_invitations'] = events_invitations_json(band.event_invitations) if includes.include?('event_invitations')
      hash['event_invitations'] = events_invitations_json(band.event_invitations, ['with_events']) if includes.include?('event_invitations_with_events')
      hash['favorites'] = entities_json(band.favorite_entities) if includes.include?('favorites')
      hash['favorited_by'] = entities_json(band.favorited_by) if includes.include?('favorited_by')
      hash['reviews'] = reviews_json(band.reviews) if includes.include?('reviews')
      hash['reviews_with_reviewers'] = reviews_json(band.reviews, ['reviewer']) if includes.include?('reviews_with_reviewers')
      hash['reviews_given'] = reviews_json(band.reviews_given) if includes.include?('reviews_given')
      hash['reviews_given_with_reviewee'] = reviews_json(band.reviews_given, ['reviewee']) if includes.include?('reviews_given_with_reviewee')
      hash['notifications'] = notifications_json(band.notifications) if includes.include?('notifications')
      hash['new_notifications'] = notifications_json(band.notifications, ['new']) if includes.include?('new_notifications')
      hash['read_notifications'] = notifications_json(band.notifications, ['read']) if includes.include?('read_notifications')
    end
  end

  def bands_json(bands, includes = [])
    bands.map { |b| band_json(b, includes) }
  end
end
