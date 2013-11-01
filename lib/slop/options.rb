module Slop
  class Options
    include Enumerable

    attr_reader :options

    def initialize
      @options = []
    end

    def <<(option)
      options << option
    end

    def find_by_flag(flag)
      flag = flag.to_s.sub(/\A--?/, '')
      options.find { |o| o.long == flag || o.short == flag }
    end

    def each(&block)
      options.each(&:block)
    end

  end
end
