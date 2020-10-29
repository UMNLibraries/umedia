# frozen_string_literal: true

namespace :ingest do
  desc 'Index Collection (name, desc) metadata'
  task :collection_metadata, [:set_spec] => :environment do |_t, args|
    if args[:set_spec]
      IndexCollections.new(set_spec: args[:set_spec])
    else
      IndexCollections.new
    end.index!
  end

  desc 'Delete Collection Metadata'
  task collection_metadata_delete: [:environment] do
    SolrClient.new.solr.delete_by_query('document_type:collection')
  end

  desc 'Index a single collection'
  task :collection, [:set_spec] => :environment do |_t, args|
    run_etl!([args[:set_spec]])
  end

  desc 'Index a single collection of records with updates within the last day'
  task :collection_daily, [:set_spec] => :environment do |_t, args|
    run_etl!([args[:set_spec]], one_day_ago)
  end

  desc 'Index all records with updates within the last day'
  task collections_daily: [:environment] do
    run_etl!(etl.set_specs, one_day_ago)
  end

  desc 'Index all collections'
  task collections: [:environment] do
    run_etl!(etl.set_specs)
  end

  desc 'Nuke Sidekiq Queue'
  task clear_sidekiq: [:environment] do
    Sidekiq::Queue.new.clear
  end

  desc 'Index Transcripts from a Single Collection'
  task :collection_transcript, [:set_spec] => :environment do |_t, args|
    TranscriptsIndexerWorker.perform_async(1, args[:set_spec])
  end

  desc 'Index Transcripts from all Collections'
  task collection_transcripts: [:environment] do
    etl.set_specs.map { |set_spec| TranscriptsIndexerWorker.perform_async(1, set_spec) }
  end

  desc 'Index Transcripts from all Collections with updates within the last day'
  task collection_transcripts_daily: [:environment] do
    etl.set_specs.map { |set_spec| TranscriptsIndexerWorker.perform_async(1, set_spec, one_day_ago) }
  end

  desc 'Index A controlled set of sample items (used to generage the test index)'
  task sample_records: [:environment] do
    JSON.parse(File.read(Rails.root.join('sample-records.json'))).map do |id|
      index_record(id)
    end
  end

  desc 'Index a single record.'
  task :record, [:id] => :environment do |_t, args|
    index_record(args[:id])
  end

  # HELPERS

  def one_day_ago
    1.day.ago.to_date.to_s
  end

  def run_etl!(set_specs = [], after_date = false)
    puts "Indexing Sets: '#{set_specs.join(', ')}'"
    config = after_date ? etl.config.merge(after_date: after_date) : etl.config
    CDMDEXER::ETLBySetSpecs.new(set_specs: set_specs, etl_config: config).run!
  end

  def index_record(id)
    IndexRecord.new(
      record_id: id,
      solr_url: config[:solr_config][:url],
      cdm_endpoint: config[:cdm_endpoint],
      oai_endpoint: config[:oai_endpoint],
      field_mappings: config[:field_mappings]
    ).index!
  end

  def config
    etl.config
  end

  def etl
    @etl ||= UmediaETL.new
  end
end
