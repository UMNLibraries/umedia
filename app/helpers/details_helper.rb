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
          { name: 'notes' }
        ]
      },
      {
        label: 'Physical Description',
        fields: [
          { name: 'types', facet: 'types' },
          { name: 'format_name', facet: true },
          { name: 'dimensions' }
        ]
      },
      {
        label: 'Topics',
        fields: [
          { name: 'subject_ss', facet: true },
          { name: 'subject_fast_ss', facet: true },
          { name: 'language', facet: true }
        ]
      },
      {
        label: 'Geographic Location',
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
        label: 'Collection Information',
        fields: [
          { name: 'parent_collection_name', facet: true },
          { name: 'contributing_organization_name_s', facet: true },
          { name: 'contact_information' },
          { name: 'fiscal_sponsor' }
        ]
      },
      {
        label: 'Identifiers',
        fields: [
          { name: 'local_identifier' },
          { name: 'barcode' },
          { name: 'system_identifier' },
          { name: 'dls_identifier' },
          { name: 'persistent_url' }
        ]
      },
      {
        label: 'Can I use It?',
        fields: [
          { name: 'local_rights' },
          { name: 'standardized_rights' },
          { name: 'rights_statement_uri' }
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

  def render_rights_section(item)
    rights_uri = item.field_rights_statement_uri.value
    render 'rights_field_section', rights: rights(rights_uri), local_rights: item.field_local_rights.value
  end

  def field_section(section, item)
    case section[:label]
    when 'Can I use It?'
      render_rights_section(item)
    else
      render 'field_section', label: section[:label],
                              values: section_values(item, section)
    end
  end

  def section_values(item, section)
    Umedia::ItemDetailsFields.new(field_configs: section[:fields],
                                  item: item).displayables
  end

  def collection_description(item)
    auto_link(item.field_collection_description.value)
  end
end
