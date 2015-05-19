require 'action_controller'

require 'ensure_param_exists'
require 'pry'

class TestClass < ActionController::Base
  include EnsureParamExists
end

describe EnsureParamExists do
  before :each do
    class TestClass
      attr_accessor :params
    end
  end

  subject { TestClass.new }

  context "ensure_param" do
    it "sets a before_filter" do
      TestClass.should_receive(:before_filter).with(:ensure_p1_exists, {})

      class TestClass
        ensure_param :p1
      end
    end

    it "sets a before_filter with opts" do
      TestClass.should_receive(:before_filter).with(:ensure_p1_exists, { only: [:show] })

      class TestClass
        ensure_param :p1, only: [:show]
      end
    end

    context "generated method logic" do
      it "accepts symbols" do
        class TestClass
          ensure_param :p1
        end

        TestClass.method_defined?(:ensure_p1_exists).should be_true
      end

      context "param is not set" do
        before :each do
          class TestClass
            ensure_param :p1
          end

          subject.params = { p1: nil }
        end

        it "renders with status: 422" do
          subject.should_receive(:render).with(hash_including(status: 422))
          subject.ensure_p1_exists
        end

        it "renders with an error response" do
          subject.should_receive(:render).with(hash_including(json: { success: false, message: "missing p1 parameter" }))
          subject.ensure_p1_exists
        end
      end
    end
  end

  context "ensure_any_params" do
    it "sets a before_filter" do
      TestClass.should_receive(:before_filter).with(:ensure_p1_or_p2_exists, {})

      class TestClass
        ensure_any_params :p1, :p2
      end
    end

    it "sets a before_filter with opts" do
      TestClass.should_receive(:before_filter).with(:ensure_p1_or_p2_exists, { only: [:show] })

      class TestClass
        ensure_any_params :p1, :p2, only: [:show]
      end
    end

    context "generated method logic" do
      before :each do
        class TestClass
          ensure_any_params :p1, :p2
        end
      end

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

    context "ensure_all_params" do
      it "sets a before_filter" do
        TestClass.should_receive(:before_filter).with(:ensure_p1_and_p2_exists, {})

        class TestClass
          ensure_all_params :p1, :p2
        end
      end

      it "sets a before_filter with opts" do
        TestClass.should_receive(:before_filter).with(:ensure_p1_and_p2_exists, { only: [:show] })

        class TestClass
          ensure_all_params :p1, :p2, only: [:show]
        end
      end

      context "generated method logic" do
        before :each do
          class TestClass
            ensure_all_params :p1, :p2
          end
        end

        it "accepts symbols" do
          TestClass.method_defined?(:ensure_p1_and_p2_exists).should be_true
        end

        it "returns nil if parameter 1 and parameter 2 are set" do
          subject.params = { p1: 'set', p2: 'set' }
          subject.should_not_receive(:render)

          subject.ensure_p1_and_p2_exists
        end

        it "renders status: 422 if parameter 1 is set and parameter 2 is not set" do
          subject.params = { p1: 'set', p2: nil }
          subject.should_receive(:render).with(hash_including(status: 422))

          subject.ensure_p1_and_p2_exists
        end

        it "returns status: 422 if parameter 1 is not set and parameter 2 is set" do
          subject.params = { p1: 'set', p2: nil }
          subject.should_receive(:render).with(hash_including(status: 422))

          subject.ensure_p1_and_p2_exists
        end

        context "parameters 1 and parameters 2 not set" do
          before :each do
            subject.params = { p1: nil, p2: nil }
          end

          it "renders with status: 422" do
            subject.should_receive(:render).with(hash_including(status: 422))
            subject.ensure_p1_and_p2_exists
          end

          it "renders with an error response" do
            subject.should_receive(:render).with(hash_including(json: { success: false, message: "missing p1 and p2 parameter" }))
            subject.ensure_p1_and_p2_exists
          end
        end
      end
    end
  end

end
