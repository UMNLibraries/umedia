namespace :umedia_ingest do
  desc 'Index All UMedia Collections'
  desc 'Index a single collection'
  task :batch, [:set_spec] => :environment  do |t, args|
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

  def run_etl!(set_specs = [])
    puts "Indexing Sets: '#{set_specs.join(', ')}'"
    CDMBL::ETLBySetSpecs.new(set_specs: set_specs, etl_config: etl.config).run!
  end

  def etl
    @etl ||= UmediaETL.new
  end
end
