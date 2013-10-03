require 'rails'
require 'action_controller'

module EnsureParamExists
  extend ActiveSupport::Concern

  included do
    def self.ensure_param(expected_param, opts = {})
      _ensure_param_exists_(:and, [expected_param, opts])
    end

    def self.ensure_any_params(*expected_params)
      _ensure_param_exists_(:or, expected_params)
    end

    def self.ensure_all_params(*expected_params)
      _ensure_param_exists_(:and, expected_params)
    end

    def self._ensure_param_exists_(operator, expected_params)
      opts = expected_params.last.kind_of?(Hash) ? expected_params.pop : {}

      method_name = "ensure_#{expected_params.join("_#{operator}_")}_exists"
      define_method(method_name) do
        return if expected_params.send(_operator_map_[operator]) { |expected_param| params[expected_param.to_sym].present? }
        render json: { success: false, message: "missing #{expected_params.join(" #{operator} ")} parameter" }, status: 422
      end

      before_filter method_name.to_sym, opts
    end

    def _operator_map_
      { and: 'all?', or: 'any?' }
    end
  end
end
