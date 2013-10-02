require 'rails'

module EnsureParamExists
  extend ActiveSupport::Concern

  included do
    def self.define_ensure_param_exists_for(*expected_params)
      expected_params.each do |expected_param|
        method_name = "ensure_#{expected_param}_exists"
        define_method(method_name) do
          return unless params[expected_param.to_sym].blank?
          render json: { success: false, message: "missing #{expected_param.to_s} parameter" }, status: 422
        end
      end
    end

    def self.define_ensure_any_param_exists_for(*expected_params)
      method_name = "ensure_#{expected_params.join("_or_")}_exists"
      define_method(method_name) do
        return unless expected_params.all? { |expected_param| params[expected_param.to_sym].blank? }
        render json: { success: false, message: "missing #{expected_params.join(" or ")} parameter" }, status: 422
      end
    end
  end

end
