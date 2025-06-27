module RansackSearchable
  extend ActiveSupport::Concern

  included do
    helper_method :ransack_query
  end

  def ransack_query(model, defaults = {})
    search_params = params[:q] ? params[:q].merge(defaults) : defaults
    instance_variable_set("@q", model.ransack(search_params))
    @q
  end
end
