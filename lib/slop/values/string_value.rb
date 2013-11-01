module Slop::Values
  class StringValue < Slop::Value
    def call(value)
      value.to_s
    end
  end
end
