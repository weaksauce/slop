module Slop::Processors
  class BooleanProcessor < Slop::Processor

    def call(*)
      true
    end

    def option_config
      { expects_argument: false }
    end

  end
end
