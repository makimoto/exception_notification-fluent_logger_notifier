require "fluent-logger"
module ExceptionNotifier
  class FluentLoggerNotifier

    attr_accessor :logger, :template
    class ConfigurationError < Exception;end

    def initialize(options)
      @template = options.delete(:template)
      raise ConfigurationError, "`template` key must be set" unless @template

      logger_settings = options.delete(:logger_settings) || {}
      if options.delete(:test_logger)
        @logger = Fluent::Logger::TestLogger.new
      else
        tag_prefix = options.delete(:tag_prefix)
        @logger = Fluent::Logger::FluentLogger.new(tag_prefix, logger_settings)
      end
    end

    def call(exception, options={})
      arg = Argument.build(template, exception, options)
      logger.post(nil, arg)
    end

    class SetupError < Exception;end

    class Argument
      def initialize(template, exception, options = {})
        @exception = exception
        @options = options
        @template = template
      end

      def build
        expand_object(@template)
      end

      def self.build(template, exception, options = {})
        self.new(template, exception, options).build
      end

      private

      def expand_object(obj)
        case obj
        when Hash
          expand_hash(obj)
        when Array
          expand_array(obj)
        when Proc
          expand_proc(obj)
        else
          obj
        end
      end

      def expand_proc(prok)
        expand_object(prok.call(@exception, @options))
      end

      def expand_array(array)
        array.map {|element| expand_object(element) }
      end

      def expand_hash(hash)
        {}.tap do |result|
          hash.each do |k, v|
            result[k] = expand_object(v)
          end
        end
      end
    end
  end
end
