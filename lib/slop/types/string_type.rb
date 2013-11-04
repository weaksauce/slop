module Slop::Types
  class StringType < Slop::Type
    def call(value)
      value.to_s
    end
  end
end
