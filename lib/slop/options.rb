module Slop
  class Options
    include Enumerable

    attr_reader :options
    attr_reader :separators
    attr_reader :parser
    attr_accessor :banner

    def initialize
      @options    = []
      @separators = []
      @banner     = "usage: #{$0} [options]"
      @parser     = Parser.new(self)
    end

    def add(*flags, **config)
      desc   = flags.pop unless flags.last.start_with?('-')
      type   = config.delete(:type) || "string"
      klass  = Slop.string_to_option_class(type.to_s)
      option = klass.new(flags, desc, config)

      add_option option
    end

    def separator(string)
      if separators[options.size]
        separators.last << "\n#{string}"
      else
        separators[options.size] = string
      end
    end

    def parse(strings)
      parser.parse(strings)
    end

    def each(&block)
      options.each(&block)
    end

    def method_missing(name, *args, **config, &block)
      if respond_to_missing?(name)
        config[:type] = name
        add(*args, config, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      Slop.option_defined?(name) || super
    end

    def to_a
      options.dup
    end

    def to_s(prefix: " " * 4)
      str = banner + "\n"
      len = longest_flag_length

      options.each_with_index do |opt, i|
        if sep = separators[i]
          str << "#{sep}\n"
        end
        str << "#{prefix}#{opt.to_s(offset: len)}\n"
      end

      str
    end

    private

    def longest_flag_length
      (o = longest_option) && o.flag.length || 0
    end

    def longest_option
      options.max { |a, b| a.flag.length <=> b.flag.length }
    end

    def add_option(option)
      options.each do |o|
        flags = o.flags & option.flags
        if flags.any?
          raise ArgumentError, "duplicate flags: #{flags}"
        end
      end

      options << option
      option
    end
  end
end
