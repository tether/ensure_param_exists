require 'rails'
require 'action_controller'

module EnsureParamExists
  extend ActiveSupport::Concern

  included do
    def self.ensure_param(expected_param, opts = {})
      method_name = "ensure_#{expected_param}_exists"
      define_method(method_name) do
        return unless params[expected_param.to_sym].blank?
        render json: { success: false, message: "missing #{expected_param.to_s} parameter" }, status: 422
      end

      before_filter method_name.to_sym, opts
    end

    def self.ensure_any_params(*expected_params)
      opts = expected_params.last.kind_of?(Hash) ? expected_params.pop : {}

      method_name = "ensure_#{expected_params.join("_or_")}_exists"
      define_method(method_name) do
        return if expected_params.any? { |expected_param| params[expected_param.to_sym].present? }
        render json: { success: false, message: "missing #{expected_params.join(" or ")} parameter" }, status: 422
      end

      before_filter method_name.to_sym, opts
    end

    def self.ensure_all_params(*expected_params)
      opts = expected_params.last.kind_of?(Hash) ? expected_params.pop : {}

      method_name = "ensure_#{expected_params.join("_and_")}_exists"
      define_method(method_name) do
        return if expected_params.all? { |expected_param| params[expected_param.to_sym].present? }
        render json: { success: false, message: "missing #{expected_params.join(" and ")} parameter" }, status: 422
      end

      before_filter method_name.to_sym, opts
    end
  end
end
