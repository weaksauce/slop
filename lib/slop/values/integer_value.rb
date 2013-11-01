module Slop::Values
  class IntegerValue < Slop::Value
    def call(value)
      value.to_i
    end
  end
end
