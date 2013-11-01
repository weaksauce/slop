module Slop
  class Option

    attr_reader :attributes
    attr_writer :writer
    attr_accessor :short, :long, :description, :block, :count, :argument


    def initialize(attributes = {}, &block)
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

    def run_block
      @value = attributes[:value].call(@argument)
      block.call(@value) if block
    end

  end
end
