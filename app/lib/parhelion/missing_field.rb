module Parhelion
  class MissingField < Field
    def exists?
      false
    end
  end
end