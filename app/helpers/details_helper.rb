# frozen_string_literal: true

module DetailsHelper
  def field_sections
    [
      {
        fields: [
          { name: 'title' },
          { name: 'title_alternative' },
          { name: 'description' },
          { name: 'date_created_ss', facet: true },
          { name: 'historical_era' },
          { name: 'creator_ss', facet: true },
          { name: 'contributor', facet: true },
          { name: 'publisher' },
          { name: 'caption' },
          { name: 'notes' },
        ]
      },
      {
        label: 'physical_description',
        fields: [
          { name: 'types', facet: 'types' },
          { name: 'format_name', facet: true },
          { name: 'dimensions' }
        ]
      },
      {
        label: 'topics',
        fields: [
          { name: 'subject_ss', facet: true },
          { name: 'subject_fast_ss', facet: true },
          { name: 'language', facet: true },
        ]
      },
      {
        label: 'geographic_location',
        fields: [
          { name: 'city', facet: true },
          { name: 'state', facet: true },
          { name: 'country', facet: true },
          { name: 'region', facet: true },
          { name: 'continent', facet: true },
          { name: 'geonames' },
          { name: 'projection' },
          { name: 'scale' },
          { name: 'coordinates' },
        ]
      },
      {
        label: 'collection_info',
        fields: [
          { name: 'parent_collection_name', facet: true },
          { name: 'contributing_organization_name_s', facet: true },
          { name: 'contact_information' },
          { name: 'fiscal_sponsor' }
        ]
      },
      {
        label: 'identifiers',
        fields: [
          { name: 'local_identifier' },
          { name: 'barcode' },
          { name: 'system_identifier' },
          { name: 'dls_identifier' },
          { name: 'persistent_url' }
        ]
      },
      {
        label: 'rights',
        fields: [
          { name: 'local_rights' },
          { name: 'standardized_rights' },
          { name: 'rights_statement_uri' },
          { name: 'expected_public_domain_year' },
          { name: 'additional_rights_information' },
        ]
      },
      {
        fields: [
          { name: 'translation' }
        ]
      }
    ]
  end

  def rights(rights_uri)
    RightsStatements.new(rights_uri: rights_uri)
  end

  def render_rights_section(item, label, locale = :en)
    locale_prefix = locale == :en ? '' : "#{locale.to_s}_"
    rights_uri = item.send("field_#{locale_prefix}rights_statement_uri".to_sym).value
    local_rights_locale = item.send("field_#{locale_prefix}local_rights".to_sym).value
    render 'rights_field_section', rights: rights(rights_uri), local_rights: local_rights_locale, label: label
  end

  def field_section(section, item, locale)
    case section[:label]
    when 'rights'
      render_rights_section(item, section[:label], locale)
    else
      render 'field_section', label: section[:label],
                              values: section_values(item, section, locale)
    end
  end

  def section_values(item, section, locale)
    Umedia::ItemDetailsFields.new(field_configs: section[:fields],
                                  item: item,
                                  locale: locale).displayables
  end

  def has_locale?(item, locale)
    available_locales(item).include? locale
  end

  def available_locales(item)
    [I18n.default_locale] + ([item.public_send(:field_alternate_languages).value].flatten - [nil,false]).map(&:to_sym).uniq
  end

  def collection_description(item)
    auto_link(item.field_collection_description.value)
  end
end
