module EventContext
  extend ActiveSupport::Concern
  extend PatternHelper
  included do
    append_before_action :determine_context

    def determine_context
      if event = Event.accessible_by(current_ability).find_by(id: params[:event_id] || current_or_blank_event)
        @context ||= event
        @event = event
      end
    end

    def current_or_blank_event
      params[:event_id].present? ? Event.find(params[:event_id]) : Event.new(id: -1)
    end

  end
end
