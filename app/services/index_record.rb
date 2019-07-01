class IndexRecord
  attr_reader :worker_klass,
              :record_id,
              :solr_url,
              :cdm_endpoint,
              :oai_endpoint,
              :field_mappings

  def initialize(worker_klass: CDMDEXER::TransformWorker,
                 record_id: :MISSING_RECORD_ID,
                 solr_url: :MISSING_SOLR_URL,
                 cdm_endpoint: :MISSING_CDM_ENDPOINT,
                 oai_endpoint: :MISSING_OAI_ENDPOINT,
                 field_mappings: :MISSING_FIELD_MAPPINGS)
    @worker_klass = worker_klass
    @record_id = record_id
    @solr_url = solr_url
    @cdm_endpoint = cdm_endpoint
    @oai_endpoint = oai_endpoint
    @field_mappings = field_mappings
  end

  def index!
    worker_klass.perform_async(
      [{ id: record_id }],
      { url: solr_url },
      cdm_endpoint,
      oai_endpoint,
      field_mappings,
      1
    )
  end
end
