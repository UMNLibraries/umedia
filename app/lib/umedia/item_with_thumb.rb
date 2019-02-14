# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class ItemWithThumb
    attr_reader :item, :thumb_klass
    def initialize(item: :MISSING_ITEM,
                   thumb_klass: Thumbnail::Url)
      @item = item
      @thumb_klass = thumb_klass
    end

    def to_h
      item.to_h.merge(thumb_url: thumb.to_s, thumb_cdn_url: thumb.to_cdn_s)
    end

    private

    def thumb
      @thumb ||= thumb_klass.new(item: item)
    end
  end
end