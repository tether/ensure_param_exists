require 'ensure_param_exists'

class TestClass
  include EnsureParamExists
end

describe EnsureParamExists do
  it "accepts symbols" do
    class TestClass
      define_ensure_param_exists_for :test
    end

    TestClass.method_defined?(:ensure_test_exists).should be_true
  end

  it "accepts arrays" do
    class TestClass
      define_ensure_param_exists_for :test, :test2
    end

    TestClass.method_defined?(:ensure_test2_exists).should be_true
  end
end

