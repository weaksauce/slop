module Slop
  class OptionConfig
    attr_reader :config, :values

    def self.build(values)
      config = new(values)
      config.build
      config.config
    end

    def initialize(values)
      @config = values[-1].is_a?(Hash) ? values.pop : {}
      @values = values
    end

    def build
      case values.size
      when 3
        merge_all
      when 2
        add_flag values[0]
        add_description values[1]
      when 1
        add_flag values[0]
      else
        raise
      end
    end

    private

    def add_flag(flag)
      if flag.size == 1
        config[:short] = flag
      else
        config[:long] = flag
      end
    end

    def add_description(string)
      if string =~ /[A-Z\s]+/
        config[:description] = string
      else
        config[:long] = string
      end
    end

    def merge_all
      config.merge!(
        short:       values[0],
        long:        values[1],
        description: values[2],
      )
    end

  end
end
