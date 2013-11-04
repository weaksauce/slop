module Slop
  class Parser
    attr_reader :config, :builder, :options, :result

    def initialize(builder, config = {}, &block)
      @config  = config
      @builder = builder
      @options = []
      @result  = Result.new(builder, self)
    end

    def parse(items = ARGV, &block)
      items.each_cons(2).each { |flag, arg| parse_item(flag, arg) }
      parse_item(items.last, nil) # each cons misses the last flag

      options.each { |opt| opt.call(result) }

      result
    end

    private

    def parse_item(flag, argument)
      if flag.start_with?('-')
        flag, argument = flag.split('=') if flag.include?('=')
        option = builder.find_option(flag)

        if option
          if option.argument? && argument.nil?
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
