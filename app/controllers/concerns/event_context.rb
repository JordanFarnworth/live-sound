module EventContext
  extend ActiveSupport::Concern
  extend PatternHelper
  included do
    before_action :determine_context

    def determine_context
      return unless @content.nil?
      if match = request.path.match(PatternHelper::EVENT_ROUTES)
        class_name = match[1]
        clazz = class_name.classify.constantize
        # new :read permission check here
        # @context = clazz.accessible_by(current_ability).find params["#{class_name.singularize}_id"]
        @context = Event.find params[:event_id] || event_member_params[:event_id]
        # new query here
        has_context = @context.class.with_user_as_member(current_or_blank_user.id).include? @context
        unless has_context
          render json: { message: 'You are not authorized to access this resource' }, status: :unauthorized
        end
      end
    end

  end
end
