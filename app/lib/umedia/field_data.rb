module Umedia
  # Retrieve an item or its children where data is not null for a given field
  class FieldData
    attr_reader :parent_id, :field, :item_klass, :children
    def initialize(parent_id: :MISSING_PARENT_ID,
                   field: :MISSING_SOLR_FIELD_NAME,
                   check_exists: false,
                   item_klass: Item,
                   children_klass: Children)
      @parent_id = parent_id
      @field = field
      # if check_exists == true, we'll only search for one row. Otherwise, we
      # retrieve all children whwere a given field is not null.
      @item_klass = item_klass

      @children = children_klass.new(parent_id: parent_id,
                                     check_exists: check_exists,
                                     fq: fq)
    end

    # Limit only to children with transcript data
    # this is the equivalent of a solr not null query
    def fq
      ["#{field}:[* TO *]"]
    end

    # A little faster than items.emtpy? when check_exists is set to true
    def empty?
      if item.is_compound?
        children.num_found == 0
      else
        !item?
      end
    end

    def items
      if item.is_compound?
        children.find.map do |child|
          child
        end
      elsif item?
        [item]
      else
        []
      end
    end

    private

    # check a non-compound to see if a value exists for the given field
    def item?
      !item.public_send("field_#{field}").public_send("value").blank?
    end

    def item
      @item ||= item_klass.find(parent_id)
    end
  end
end