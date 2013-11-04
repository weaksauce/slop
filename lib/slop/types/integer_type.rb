module Slop::Types
  class IntegerType < Slop::Type
    def call(value)
      value.to_i
    end
  end
end
