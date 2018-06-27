# frozen_string_literal: true

module Parhelion
  # Converts a result hash into an Document object with Field Object children
  class Document
    attr_reader :doc_hash, :field_klass
    def initialize(doc_hash: {}, field_klass: Field)
      @doc_hash    = doc_hash
      @field_klass = field_klass
    end

    def id
      doc_hash.fetch('id')
    end

    def is_compound?
      doc_hash.fetch('page_count', 1) > 1
    end

    def method_missing(method_name, *arguments, &block)
      if method_name.to_s =~ /field_(.*)/
        field($1, field_value($1))
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.start_with?('field_') || super
    end

    def ==(other)
      doc_hash == other.doc_hash
    end

    private

    def field(name, value)
      field = doc_hash.key?(name) ? field_klass : MissingField
      field.new name: name, value: value
    end

    def field_value(field)
      doc_hash.fetch(field, false)
    end
  end
end
