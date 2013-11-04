module Slop
  class Builder
    attr_reader :parser, :options

    def initialize(parser)
      @parser  = parser
      @options = Options.new
      @values  = []
    end

    def on(*values, &block)
      config = OptionConfig.build(values)
      config[:type] ||= :string
      option = Option.new(parser, config, &block)
      options << option
      option
    end

    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        config = args[-1].is_a?(Hash) ? args.pop : {}
        config[:type] ||= method_name
        args << config
        on(*args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      Type.exists?(method_name) || super
    end

  end
end
