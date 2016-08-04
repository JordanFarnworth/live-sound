module EntityContext
  extend ActiveSupport::Concern
  included do
    before_action :set_context

    def set_context
      if match = request.path.match(/(bands|enterprises|private_parties|users)/)
        class_name = match[1]
        clazz = class_name.classify.constantize
        @context = clazz.accessible_by(current_ability).find params["#{class_name.singularize}_id"]
      end
    end
  end
end
