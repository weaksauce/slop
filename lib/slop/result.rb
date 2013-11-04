module Slop
  class Result

    attr_reader :builder, :parser

    def initialize(builder, parser)
      @builder = builder
      @parser  = parser
    end

    def find_option(flag)
      builder.find_option(flag)
    end

    def [](flag)
      option = find_option(flag)
      option && option.value
    end

    def method_missing(method_name, *args)
      if respond_to_missing?(method_name)
        name = method_name.to_s[0..-2]
        find_option(name).count > 0
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super unless method_name.to_s.end_with?('?')
      name = method_name.to_s[0..-2]
      find_option(name) || super
    end

    def to_hash
      builder.options.each_with_object({}) do |option, result|
        result[option.key] = option.value
      end
    end

  end
end
