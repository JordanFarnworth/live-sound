def log_out(user = nil)
  if user
    JwtSession.where(user: user).destroy_all
  else
    JwtSession.destroy_all
  end
  controller.instance_variable_set(:@jwt_session, nil)
  request.headers['Authorization'] = nil
end
