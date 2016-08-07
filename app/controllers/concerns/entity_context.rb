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
  end
end
