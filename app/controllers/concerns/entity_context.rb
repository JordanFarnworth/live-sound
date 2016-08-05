module EntityContext
  extend ActiveSupport::Concern
  extend PatternHelper
  included do
    before_action :set_context

    def set_context
      if match = request.path.match(PatternHelper::ENTITY_ROUTES)
        class_name = match[1]
        clazz = class_name.classify.constantize
        @context = clazz.accessible_by(current_ability).find params["#{class_name.singularize}_id"]
      end
    end

    def current_ability
      if @context
        @current_context_ability ||= Ability.new(current_user, @context)
      else
        super
      end
    end
  end
end
