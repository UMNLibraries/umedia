# frozen_string_literal: true

module Parhelion
  # Converts a result hash into an Item object with Field Object children
  class Item
    attr_reader :doc_hash, :field_klass, :cdn_iiif_klass
    def initialize(doc_hash: {},
                   field_klass: Field,
                   cdn_iiif_klass: IiifConfig)
      @doc_hash     = doc_hash
      @field_klass  = field_klass
      @cdn_iiif_klass = cdn_iiif_klass
    end

    def url
      "#{ENV['RAILS_BASE_URL']}/item/#{index_id}"
    end

    def height
      iiif_info.fetch('height', 0)
    end

    def width
      iiif_info.fetch('width', 0)
    end

    def type
      doc_hash.fetch('types', []).first
    end

    # Solr index identifier, also used in item path
    # items/coll123:999 <-- path id
    def index_id
      doc_hash.fetch('id')
    end

    def id
      doc_ids.last
    end

    # If an item doesn't have a parent ID field,
    # it is its own parent
    def parent_id
      parent_ids.last
    end

    def collection
      doc_ids.first
    end

    def is_compound?
      doc_hash['viewer_type'] == 'COMPOUND_PARENT_NO_VIEWER'
    end

    def ==(other)
      doc_hash == other.doc_hash
    end

    def to_h
      doc_hash.merge(
        'type' => type,
        'collection' => collection,
        'is_compound' => is_compound?,
        'parent_id' => parent_id
      )
    end

    private

    def iiif_info
      if !is_compound?
        @iiif_info ||= cdn_iiif_klass.new(id: id, collection: collection).info
      else
        {}
      end
    end

    def doc_ids
      index_id.split(':')
    end

    def parent_ids
      doc_hash.fetch('parent_id', index_id).split(':')
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

    def field(name, value)
      field = doc_hash.key?(name) ? field_klass : MissingField
      field.new name: name, value: value
    end

    def field_value(field)
      doc_hash.fetch(field, false)
    end
  end
end
