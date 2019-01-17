module Umedia
  class Collection
    attr_reader :set_spec, :name, :description
    def initialize(set_spec: false, name: '', description: '')
      raise ArgumentError.new("Required Argument: set_spec") unless set_spec
      @set_spec = set_spec
      @name = name
      @description = description
    end

    # Since our CDM instance has both Reflections and UMedia content in it and
    # we can't choose setSpec names, we have a collection naming convention that
    # helps us identify which collections are reflections and which are umedia.
    # We chop this information off for public display
    def display_name
      name.gsub(/^ul_([a-zA-Z0-9])*\s-\s/, '')
    end
  end
end