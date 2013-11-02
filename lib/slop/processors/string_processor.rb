module Slop::Processors
  class StringProcessor < Slop::Processor
    def call(value)
      value.to_s
    end
  end
end
