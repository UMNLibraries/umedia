module Parhelion
  class MissingField < Field
    def missing?
      true
    end
    def exists?
      false
    end
  end
end