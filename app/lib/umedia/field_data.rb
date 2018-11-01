module Umedia
  # Retrieve an item or its children where data is not null for a given field
  class FieldData
    attr_reader :id, :field, :check_exists, :item_klass, :children_klass
    def initialize(id: :MISSING_ID,
                   field: :MISSING_SOLR_FIELD_NAME,
                   check_exists: false,
                   item_klass: Item,
                   children_klass: Children)
      @id = id
      @field = field
      # if check_exists == true, we'll only search for one row. Otherwise, we
      # retrieve all children whwere a given field is not null.
      @check_exists = check_exists
      @item_klass = item_klass
      @children_klass = children_klass
    end

    # Limit only to children with transcript data
    # this is the equivalent of a solr not null query
    def fq
      ["#{field}:[* TO *]"]
    end

    def items
      if item.is_compound?
        children_klass.find(id, check_exists: check_exists, fq: fq).map do |child|
          child
        end
      else
        [item]
      end
    end

    def item
      @item ||= item_klass.find(id)
    end
  end
end