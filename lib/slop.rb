require 'slop/type'
require 'slop/option'
require 'slop/option_config'
require 'slop/builder'
require 'slop/parser'

module Slop
  VERSION = '4.0.0'

  def self.parse(items = ARGV, config = {}, &block)
    config, items = items, ARGV if items.is_a?(Hash) && config.empty?
    builder = Builder.new(config)
    yield builder if block_given?
    parser = Parser.new(builder, config, &block)
    parser.parse(items)
    parser
  end
end
