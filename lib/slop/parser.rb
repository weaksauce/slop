module Slop
  class Parser
    attr_reader :config, :builder, :options

    def initialize(builder, config = {}, &block)
      @config  = config
      @builder = builder
      @options = []
    end

    def parse(items = ARGV, &block)
      items.each_cons(2).each do |flag, argument|
        parse_item(flag, argument)
      end
      parse_item(items.last, nil) # each cons misses the last flag
      options.each(&:run_block)
      items
    end

    def [](flag)
      option = find_option(flag)
      option && option.value
    end

    def find_option(flag)
      builder.find_option(flag)
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
        flag, argument = flag.split('=') if flag.include?('=')
        option = find_option(flag)

        if option
          if option.expects_argument? && argument.nil?
            raise "No argument given for `#{flag}'"
          end
          execute_option(option, argument)
        else
          if flag[1] != '-' && flag.size > 2
            parse_multiple(flag, argument)
          else
            raise "Unknown option `#{flag}'"
          end
        end
      else

      end
    end

    def parse_multiple(flag, argument)
      flag[1..-2].split('').each do |f|
        parse_item("-#{f}", nil)
      end
      parse_item("-#{flag[-1]}", argument)
    end

    def execute_option(option, argument)
      option.count += 1
      option.argument = argument
      options << option
    end

  end
end
