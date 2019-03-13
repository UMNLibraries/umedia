class UmediaETL
  attr_reader :oai_endpoint,
              :set_spec_pattern,
              :field_mappings,
              :filter_callback,
              :set_spec_filter,
              :solr_connection
  def initialize(oai_endpoint: 'http://cdm16022.contentdm.oclc.org/oai/oai.php',
                 set_spec_pattern: /^ul_([a-zA-Z0-9])*\s-\s/,
                 field_mappings: Umedia::Transformer.field_mappings,
                 filter_callback: CDMDEXER::RegexFilterCallback,
                 set_spec_filter: CDMDEXER::FilteredSetSpecs,
                 solr_connection: SolrClient.new)
    @oai_endpoint     = oai_endpoint
    @set_spec_pattern = set_spec_pattern
    @field_mappings   = field_mappings
    @filter_callback  = filter_callback
    @set_spec_filter  = set_spec_filter
    @solr_connection  = solr_connection
  end

  def config
    {
      oai_endpoint: oai_endpoint,
      extract_compounds: true,
      field_mappings: field_mappings,
      cdm_endpoint: 'https://server16022.contentdm.oclc.org/dmwebservices/index.php',
      max_compounds: 1,
      batch_size: 50,
      solr_config: solr_config
    }
  end

  def set_specs
    @set_specs ||= filter.set_specs
  end

  def sets
    filter.filtered_sets
  end

  private

  def callback
    filter_callback.new(field: 'setName',
                        pattern: set_spec_pattern,
                        inclusive: true)
  end

  def filter
    Rails.cache.fetch("set_specs", expires_in: 12.hours) do
      set_spec_filter.new(oai_base_url: oai_endpoint,
                          callback: callback)
    end
  end

  def solr_config
    { url: solr_connection.url }
  end
end
