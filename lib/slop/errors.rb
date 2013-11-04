module Slop
  class Error < StandardError

  end

  class UnknownOption < Error; end
  class MissingArgument < Error; end
end
