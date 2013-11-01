module Slop
  class OptionBuilder
    attr_reader :parser, :options

    def initialize(parser)
      @parser  = parser
      @options = Options.new
      @values  = []
    end

    def on(*values, &block)
      config = OptionConfig.build(values)
      option = Option.new(config, &block)
      options << option
      option
    end

    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        value  = Value.from_name(method_name).new(parser)
        config = args[-1].is_a?(Hash) ? args.pop : {}
        config = value.option_config.merge(config)
        config[:value] ||= value
        args << config
        on(*args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      Value.exists?(method_name) || super
    end

  end
end
