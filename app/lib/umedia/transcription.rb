module Umedia
  class Transcription
    attr_reader :id, :check_exists, :item_klass, :children_klass
    def initialize(id: :MISSING_ID,
                   check_exists: false,
                   item_klass: Item,
                   children_klass: Children)
      @id = id
      @check_exists = check_exists
      @item_klass = item_klass
      @children_klass = children_klass
    end

    def transcriptions
      if item.is_compound?
        children_klass.find(id, check_exists: check_exists).map do |child|
          child.field_transcription.value
        end
      else
        [item.field_transcription.value]
      end
    end

    def item
      @item ||= item_klass.find(id)
    end
  end
end