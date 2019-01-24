# frozen_string_literal: true

module Umedia
  # Fetch a list of setSpecs and convert them into collections
  class OaiSet
    attr_reader :set, :collection_klass
    def initialize(set: :MISSING_SET,
                   collection_klass: Umedia::Collection)
      @set = set
      @collection_klass = collection_klass
    end

    def to_collection
      collection_klass.new(
        set_spec: set['setSpec'],
        name: set['setName'],
        description: description
      )
    end

    private

    def description
      set.fetch('setDescription', {}).fetch('dc', {}).fetch('description', {})
    end
  end
end
