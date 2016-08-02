module Api::V1::Band
  include Api::V1::Json

  def band_json(band, includes = [])
    attributes = %w(id name description email state address youtube_link genre phone_number)

    api_json(band, only: attributes, methods: %w(class_type))
  end

  def bands_json(bands, includes = [])
    bands.map { |b| band_json(b, includes) }
  end
end
