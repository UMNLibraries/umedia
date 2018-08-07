module Umedia
  class ItemDetailsFields
    attr_reader :field_configs, :item
    def initialize(field_configs: [], item: Item.new)
      @item = item
      @field_configs = field_configs
    end

    def displayables
      fields.compact.select do |field|
        !field.missing? && field.display?
      end
    end

    private

    def fields
      field_configs.map do |field|
        value(field[:name], field[:facet])
      end
    end

    def value(name, facet)
      field = item.public_send("field_#{name}")
      field.define_singleton_method(:facet) do
        (facet) ? name : false
      end
      field
    end
  end
end
