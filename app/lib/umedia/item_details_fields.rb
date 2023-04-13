# frozen_string_literal: true
require 'i18n'

module Umedia
  class ItemDetailsFields
    attr_reader :field_configs, :item
    def initialize(field_configs: [], item: Item.new, locale: I18n.default_locale)
      @item = item
      @field_configs = field_configs
      @locale = locale
    end

    def displayables
      fields.compact.select do |field|
        field.exists? && field.display?
      end
    end

    private

    def fields
      field_configs.map do |field|
        value(field[:name], field[:facet])
      end
    end

    def value(name, facet)
      # If a locale-prefixed Solr field is present, use it, otherwise fall back to
      # a generic one. e.g. 'es_rights_statement_uri' vs 'rights_statement_uri'
      # Parhelion will return a MissingField class
      localized_name = "field_#{@locale.to_s}_#{name}"
      field = item.public_send(localized_name)
      if field.kind_of? Parhelion::MissingField
        # Fallback 
        field = item.public_send("field_#{name}")
      end
      field.define_singleton_method(:facet) do
        facet ? name : false
      end
      field
    end
  end
end
