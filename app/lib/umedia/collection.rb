# frozen_string_literal: true

module Umedia
  # Hang some UMedia-specific functionality on top of OAI Collections
  class Collection
    attr_reader :set_spec,
                :name,
                :description,
                :super_collection_names,
                :collection_count_klass
    def initialize(set_spec: false,
                   name: '',
                   description: '',
                   super_collection_names: SuperCollections.new.names,
                   collection_count_klass: CollectionCountSearch)

      raise ArgumentError.new("Required Argument: set_spec") unless set_spec
      @set_spec = set_spec
      @name = name
      @description = description
      @super_collection_names = super_collection_names
      @collection_count_klass = collection_count_klass
    end

    def item_count
      collection_count_klass.new(set_spec: set_spec).to_i
    end

    def super_collection?
      super_collection_names.include? display_name
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
