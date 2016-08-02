module Api::V1::Notification
  include Api::V1::Json

  def notification_json(notification, includes = [])
    attributes = %w(id description state created_at)

    api_json(notification, only: attributes)
  end

  def notifications_json(notifications, includes = [])
    notifications = notifications.where(state: 'read') if includes.include?('read')
    notifications = notifications.where(state: 'new') if includes.include?('new')
    notifications.map { |e| notification_json(e, includes) }
  end
end
