module Slop::Types
  class BooleanType < Slop::Type
    config argument: false

    def call(*)
      true
    end
  end
end
