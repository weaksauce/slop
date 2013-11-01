module Slop
  class Option

    attr_reader :parser, :attributes
    attr_writer :writer
    attr_accessor :short, :long, :description, :block, :count, :argument

    def initialize(parser, attributes = {}, &block)
      @parser      = parser
      @attributes  = attributes
      @short       = attributes[:short]
      @long        = attributes[:long]
      @description = attributes[:description]
      @block       = block
      @argument    = nil
      @value       = nil
      @count       = 0
    end

    def expects_argument?
      attributes[:expects_argument]
    end

    def value
      @value || @argument || attributes[:default]
    end

    def value_processor
      value = Value.from_name(attributes[:value]).new(parser)
      @attributes = value.option_config.merge(attributes)
      value
    end

    def run_block
      @value = value_processor.call(@argument)
      block.call(@value) if block
    end

  end
end
