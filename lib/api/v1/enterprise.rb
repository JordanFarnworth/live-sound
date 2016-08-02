module Api::V1::Enterprise
  include Api::V1::Json

  def enterprise_json(enterprise, includes = [])
    attributes = %w(id name description email)

    api_json(enterprise, only: attributes, methods: %w(class_type))
  end

  def enterprises_json(enterprises, includes = [])
    enterprises.map { |e| enterprise_json e, includes }
  end
end
