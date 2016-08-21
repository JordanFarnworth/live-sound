module EventContext
  extend ActiveSupport::Concern
  extend PatternHelper
  included do
    append_before_action :determine_context

    def determine_context
      if params.key? :event_id
        if event = Event.accessible_by(current_ability).find_by!(id: params[:event_id])
          @context ||= event
          @event = event
        end
      end
    end

  end
end
