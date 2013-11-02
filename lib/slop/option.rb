module Slop
  class Option

    attr_reader :parser, :attributes, :processor
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
      @processor   = Processor.from_name(attributes[:processor]).new(parser)
      @attributes  = @processor.option_config.merge(@attributes)
    end

    def expects_argument?
      attributes[:expects_argument]
    end

    def value
      @value || @argument || attributes[:default]
    end

    def run_block
      @value = processor.call(@argument)
      block.call(@value) if block
    end

  end
end
