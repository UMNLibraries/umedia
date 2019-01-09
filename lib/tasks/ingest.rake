namespace :ingest do
  desc 'Index Collection (name, desc) metadata'
  task :collection_metadata => :environment  do |t, args|
    IndexCollections.new.index!
  end

  desc 'Index a single collection'
  task :collection, [:set_spec] => :environment  do |t, args|
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
    CDMBL::ETLBySetSpecs.new(set_specs: set_specs, etl_config: etl.config).run!
  end

  desc 'Launch a background job to index a single record.'
  task :record, [:id] => :environment  do |t, args|
    config = UmediaETL.new.config
    CDMBL::TransformWorker.perform_async(
      [args[:id].split(':')],
      { url: config[:solr_config][:url]},
      config[:cdm_endpoint],
      config[:oai_endpoint],
      config[:field_mappings],
      true
    )
  end

  def etl
    @etl ||= UmediaETL.new
  end
end
