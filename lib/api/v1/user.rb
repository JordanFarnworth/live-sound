module Api::V1::User
  include Api::V1::Json
  include Api::V1::Event
  include Api::V1::EventApplication
  include Api::V1::EventInvitation
  include Api::V1::Band
  include Api::V1::Entities
  include Api::V1::Review
  include Api::V1::Notification

  def user_json(user, includes = [])
    attributes = %w(id username display_name email state single_user facebook_image_url provider)

    api_json(user, only: attributes).tap do |hash|
      includes = includes.flatten
      hash['type'] = user.class_type if includes.include?('type')
      hash['events'] = events_json(user.events_as_performer) if includes.include?('events_as_performer')
      hash['events'] = events_json(user.events_as_owner) if includes.include?('events_as_owner')
      hash['events'] = events_json(user.events_as_attendee) if includes.include?('events_as_attendee')
      hash['event_applications'] = event_applications_json(user.event_applications) if includes.include?('event_applications')
      hash['event_applications'] = event_applications_json(user.event_applications, ['with_events']) if includes.include?('event_applications_with_events')
      hash['event_invitations'] = event_invitations_json(user.event_invitations) if includes.include?('event_invitations')
      hash['event_invitations'] = event_invitations_json(user.event_invitations, ['with_events']) if includes.include?('event_invitations_with_events')
      hash['favorites'] = entities_json(user.favorite_entities) if includes.include?('favorites')
      hash['favorited_by'] = entities_json(user.favorited_by) if includes.include?('favorited_by')
      hash['reviews'] = reviews_json(user.reviews) if includes.include?('reviews')
      hash['reviews_with_reviewers'] = reviews_json(user.reviews, ['reviewer']) if includes.include?('reviews_with_reviewers')
      hash['reviews_given'] = reviews_json(user.reviews_given) if includes.include?('reviews_given')
      hash['reviews_given_with_reviewee'] = reviews_json(user.reviews_given, ['reviewee']) if includes.include?('reviews_given_with_reviewee')
      hash['notifications'] = notifications_json(user.notifications) if includes.include?('notifications')
      hash['new_notifications'] = notifications_json(user.notifications, ['new']) if includes.include?('new_notifications')
      hash['read_notifications'] = notifications_json(user.notifications, ['read']) if includes.include?('read_notifications')
    end

  end

  def users_json(users, includes = [])
    users.map { |u| user_json(u, includes) }
  end
end
