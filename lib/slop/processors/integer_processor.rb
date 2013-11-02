module Slop::Processors
  class IntegerProcessor < Slop::Processor
    def call(value)
      value.to_i
    end
  end
end
