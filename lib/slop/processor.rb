module Slop
  module Processors
  end

  class Processor
    def self.aliases
      @aliases ||= {}
    end

    def self.exists?(value)
      Processors.constants.include?(to_constant_name(value))
    end

    def self.to_constant_name(name)
      name = aliases[name.to_s] if aliases.key?(name.to_s)
      :"#{name.to_s.capitalize}Processor"
    end

    def self.from_name(name)
      Processors.const_get to_constant_name(name)
    end

    def self.add_alias(this, that)
      aliases[this.to_s] = that
    end

    add_alias "str",  "string"
    add_alias "int",  "integer"
    add_alias "bool", "boolean"

    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    alias options parser

    def call
      raise
    end

    def option_config
      { expects_argument: true }
    end

  end
end

require "slop/processors/string_processor"
require "slop/processors/integer_processor"
require "slop/processors/boolean_processor"
