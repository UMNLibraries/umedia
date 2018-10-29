module Umedia
  class Translation
    attr_reader :id, :check_exists, :item_klass, :children_klass
    def initialize(id: :MISSING_ID,
                   check_exists: false,
                   item_klass: Item,
                   children_klass: Children)
      @id = id
      # if check_exists == true, we'll only search for one row
      @check_exists = check_exists
      @item_klass = item_klass
      @children_klass = children_klass
    end

    # Limit only to children with transcript data
    # this is the equivalent of a solr not null query
    def fq
      ['translation:[* TO *]']
    end

    def translations
      if item.is_compound?
        children_klass.find(id,
                            check_exists: check_exists,
                            fq: fq).map do |child|
          child.field_translation.value
        end
      else
        [item.field_translation.value]
      end.reject(&:blank?)
    end

    def item
      @item ||= item_klass.find(id)
    end
  end
end