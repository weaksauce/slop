module Slop::Values
  class BooleanValue < Slop::Value

    def call(*)
      true
    end

    def option_config
      { expects_argument: false }
    end

  end
end
