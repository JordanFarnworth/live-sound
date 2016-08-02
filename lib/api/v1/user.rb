module Api::V1::User
  include Api::V1::Json

  def user_json(user, includes = [])
    attributes = %w(id username display_name email state single_user facebook_image_url provider)

    api_json(user, only: attributes, methods: %w(class_type))
  end

  def users_json(users, includes = [])
    users.map { |u| user_json(u, includes) }
  end
end
