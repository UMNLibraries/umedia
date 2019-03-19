namespace :ingest do
  desc 'Index Collection (name, desc) metadata'
  task :collection_metadata, [:set_spec] => :environment  do |t, args|
    if args[:set_spec]
      IndexCollections.new(set_spec: args[:set_spec])
    else
      IndexCollections.new
    end.index!
  end

  desc 'Index a single collection'
  task :collection, [:set_spec] => :environment do |t, args|
    run_etl!([args[:set_spec]])
  end

  desc 'Index all collections'
  task collections: [:environment] do
    run_etl!(etl.set_specs)
  end

  desc 'Index A Sample UMedia Collection'
  task collection_sample: [:environment] do
    run_etl!(etl.set_specs.sample(1))
  end

  desc 'Nuke Sidekiq Queue'
  task clear_sidekiq: [:environment] do
    Sidekiq::Queue.new.clear
  end

  def run_etl!(set_specs = [])
    puts "Indexing Sets: '#{set_specs.join(', ')}'"
    CDMDEXER::ETLBySetSpecs.new(set_specs: set_specs, etl_config: etl.config).run!
  end

  desc 'Index Transcripts from a Single Collection'
  task :collection_transcript, [:set_spec] => :environment do |t, args|
    TranscriptsIndexerWorker.perform_async(1, args[:set_spec])
  end

  desc 'Index Transcripts from all Collections'
  task all_collection_transcripts: [:environment] do
    TranscriptsIndexerWorker.perform_async(1, false)
  end

  desc 'Launch a background job to index a single record.'
  task :record, [:id] => :environment  do |t, args|
    config = UmediaETL.new.config
    CDMDEXER::TransformWorker.perform_async(
      [args[:id].split(':')],
      { url: config[:solr_config][:url]},
      config[:cdm_endpoint],
      config[:oai_endpoint],
      config[:field_mappings]
    )
  end

  def etl
    @etl ||= UmediaETL.new
  end
end
