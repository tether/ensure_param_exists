require 'ensure_param_exists'

class TestClass
  include EnsureParamExists
end

describe EnsureParamExists do
  context "define_ensure_param_exists_for" do
    it "accepts symbols" do
      class TestClass
        define_ensure_param_exists_for :test
      end

      TestClass.method_defined?(:ensure_test_exists).should be_true
    end

    it "accepts arrays" do
      class TestClass
        define_ensure_param_exists_for :p1, :p2
      end

      TestClass.method_defined?(:ensure_p2_exists).should be_true
    end
  end

  context "define_ensure_any_param_exists_for" do
    before :each do
      class TestClass
        attr_accessor :params
        define_ensure_any_param_exists_for :p1, :p2
      end
    end

    subject { TestClass.new }

    it "accepts symbols" do
      TestClass.method_defined?(:ensure_p1_or_p2_exists).should be_true
    end

    it "returns nil if parameter 1 and parameter 2 are set" do
      subject.params = { p1: 'set', p2: 'set' }
      subject.should_not_receive(:render)

      subject.ensure_p1_or_p2_exists
    end

    it "renders nil if parameter 1 is set and parameter 2 is not set" do
      subject.params = { p1: 'set', p2: nil }
      subject.should_not_receive(:render)

      subject.ensure_p1_or_p2_exists
    end

    it "returns nil if parameter 1 is not set and parameter 2 is set" do
      subject.params = { p1: 'set', p2: nil }
      subject.should_not_receive(:render)

      subject.ensure_p1_or_p2_exists
    end

    context "parameters 1 and parameters 2 not set" do
      before :each do
        subject.params = { p1: nil, p2: nil }
      end

      it "renders with status: 422" do
        subject.should_receive(:render).with(hash_including(status: 422))
        subject.ensure_p1_or_p2_exists
      end

      it "renders with an error response" do
        subject.should_receive(:render).with(hash_including(json: { success: false, message: "missing p1 or p2 parameter" }))
        subject.ensure_p1_or_p2_exists
      end
    end
  end
end

