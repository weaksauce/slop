module Slop
  class Parser
    attr_reader :config, :builder, :options, :parsed_options

    def initialize(config = {}, &block)
      @config  = config
      @builder = OptionBuilder.new(self)
      @options = @builder.options

      @parsed_options = []

      block.call builder if block
    end

    def parse(items = ARGV, &block)
      items.each_cons(2).each do |flag, argument|
        parse_item(flag, argument)
      end
      parse_item(items.last, nil) # each cons misses the last flag
      parsed_options.each(&:run_block)
      items
    end

    def [](flag)
      option = find_option(flag)
      option && option.value
    end

    def find_option(flag)
      options.find_by_flag(flag)
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

    private

    def parse_item(flag, argument)
      if flag.start_with?('-')
        option = find_option(flag)

        if option
          if option.expects_argument? && argument.nil?
            raise "No argument given for `#{flag}'"
          end
          execute_option(option, argument)
        else
          raise "Unknown option `#{flag}'"
        end
      else

      end
    end

    def execute_option(option, argument)
      option.count += 1
      option.argument = argument
      parsed_options << option
    end

  end
end
