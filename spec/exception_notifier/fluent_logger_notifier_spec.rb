require "spec_helper"

describe ExceptionNotifier::FluentLoggerNotifier do
  class FooException < Exception;end

  let(:exception) do
    FooException.new("bar message")
  end

  let(:notifier) do
    ExceptionNotifier::FluentLoggerNotifier.new(
      test_logger: true,
      template: {
        message: ->(exception, options) { "Exception: #{exception.class}: #{exception.message}" }
      }
    )
  end

  describe "#call" do
    it "logs valid data" do
      notifier.call(FooException.new("bar message"))
      notifier.logger.queue.last.should == { message: "Exception: FooException: bar message" }
    end
  end

  describe ExceptionNotifier::FluentLoggerNotifier::Argument do
    subject do
      ExceptionNotifier::FluentLoggerNotifier::Argument.build(template, exception, {})
    end

    context "with String" do
      let(:template) do
        "string"
      end

      it "returns string without any change" do
        should == "string"
      end
    end

    context "with Proc" do
      let(:template) do
        ->(e, opts) { "Exception: #{e.class}: #{e.message}" }
      end

      it "returns intended string" do
        should == "Exception: FooException: bar message"
      end
    end

    context "with Hash" do
      let(:template) do
        {
          class_name: ->(e, opts) { e.class.to_s },
          message: ->(e, opts) { e.message},
          baz: 42,
        }
      end

      it "returns intended hash" do
        should == { class_name: "FooException", message: "bar message", baz: 42 }
      end
    end

    context "with Array" do
      let(:template) do
        [
          ->(e, opts) { 1 + 42 },
          ->(e, opts) { e.class.to_s },
          nil,
        ]
      end

      it "returns intended array" do
        [43, "FooException", nil]
      end
    end

    context "with nested templates" do
      let(:template) do
        {
          string: "string",
          int: 42,
          hash: {
            proc: ->(e, opts) { e.class.to_s }
          },
          array: [42, ->(e, opts) { e.message }],
        }
      end

      it "returns intended value" do
        {
          string: "string",
          int: 42,
          hash: {
            proc: "FooException",
          },
          array: [42, "bar message"],
        }
      end
    end
  end
end
