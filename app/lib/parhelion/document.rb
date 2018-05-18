# frozen_string_literal: true

module Parhelion
  # Converts a result hash into an Document object with Field Object children
  class Document
    attr_reader :doc_hash, :field_order, :field_klass
    def initialize(doc_hash: {}, field_order: [], field_klass: Field)
      @doc_hash    = doc_hash
      @field_order = field_order
      @field_klas  = field_klass
    end

    def fields
      field_values.select do |field|
        if field.display?
          yield field if block_given?
          field
        end
      end
    end

    def ==(other)
      doc_hash == other.doc_hash
    end

    private

    def field_values
      field_order.map do |name|
        field(name)
      end
    end

    def field(name)
      Field.new name: name, value: doc_hash.fetch(name, '')
    end
  end
end
