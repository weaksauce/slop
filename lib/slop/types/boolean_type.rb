module Slop::Types
  class BooleanType < Slop::Type

    def call(*)
      true
    end

    def option_config
      { expects_argument: false }
    end

  end
end
