module RansackSearchable
  extend ActiveSupport::Concern

  included do
    helper_method :ransack_query
  end

  def ransack_query(model)
    instance_variable_set("@q", model.ransack(params[:q]))
    @q
  end
end
