module Slop
  class Option

    attr_reader :builder, :attributes, :type
    attr_accessor :short, :long, :description, :block, :count, :argument

    def initialize(builder, attributes = {}, &block)
      @builder     = builder
      @attributes  = attributes
      @short       = attributes[:short]
      @long        = attributes[:long]
      @description = attributes[:description]
      @block       = block
      @argument    = nil
      @value       = nil
      @count       = 0
      @attributes  = type_class.option_config.merge(@attributes)
    end

    def type_class
      @type_class ||= Type.from_name(attributes[:type])
    end

    def argument?
      attributes[:argument]
    end

    def key
      long || short
    end

    def value
      @value || @argument || attributes[:default]
    end

    def call(result)
      @value = type_class.new(result).call(@argument)
      block.call(@value) if block
    end

  end
end
