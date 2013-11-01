module Slop
  module Values
  end

  class Value
    def self.aliases
      @aliases ||= {}
    end

    def self.exists?(value)
      Values.constants.include?(to_constant_name(value))
    end

    def self.to_constant_name(name)
      name = aliases[name.to_s] if aliases.key?(name.to_s)
      :"#{name.to_s.capitalize}Value"
    end

    def self.from_name(name)
      Values.const_get to_constant_name(name)
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

require "slop/values/string_value"
require "slop/values/integer_value"
require "slop/values/boolean_value"
