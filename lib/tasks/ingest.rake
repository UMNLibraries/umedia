namespace :umedia_ingest do
  desc 'Index All UMedia Collections'
  task collections: [:environment] do
    puts "Indexing Sets: '#{umedia_etl.set_specs.join(', ')}'"
    CDMBL::ETLBySetSpecs.new(set_specs: umedia_etl.set_specs,
                             etl_config: umedia_etl.config)
                        .run!
  end

  desc 'Index A Sample UMedia Collection'
  task collection_sample: [:environment] do
    set_spec = umedia_etl.set_specs.sample(1)
    puts "Indexing Set: '#{set_spec}'"
    CDMBL::ETLBySetSpecs.new(set_specs: set_spec,
                             etl_config: umedia_etl.config)
                        .run!
  end

  def umedia_etl
    @umedia_etl ||= UmediaETL.new
  end
end
