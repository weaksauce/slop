require 'slop/type'
require 'slop/option'
require 'slop/option_config'
require 'slop/builder'
require 'slop/parser'
require 'slop/result'

module Slop
  VERSION = '4.0.0'

  def self.parse(items = ARGV, config = {}, &block)
    config, items = items, ARGV if items.is_a?(Hash) && config.empty?
    builder = Builder.new(config, &block)
    parser = Parser.new(builder, config, &block)
    parser.parse(items)
  end
end
