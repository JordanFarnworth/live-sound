module Api::V1::EventApplication
  include Api::V1::Json
  include Api::V1::Event

  def event_application_json(event_application, includes = [])
    attributes = %w(id event_id status state applicable)

    api_json(event_application, only: attributes).tap do |hash|
      hash['event'] = event_json(event_application.event) if includes.include?('with_events')
    end
  end

  def event_applications_json(event_application, includes = [])
    event_application.map { |e| event_application_json e, includes }
  end
end
