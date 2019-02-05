namespace :solr do
  desc "commit changes"
  task commit: [:environment]  do
  	SolrClient.new.commit
  end

  desc "optimize core"
  task optimize: [:environment]  do
  	SolrClient.new.optimize
  end

  desc "delete core index"
  task delete_index: [:environment]  do
  	SolrClient.new.delete_index
  end

  desc "backup solr data locally"
  task :backup, [:number_to_keep] => :environment  do |t, args|
    keep = args[:number_to_keep].blank? ? 2 : args[:number_to_keep].to_i
    SolrClient.new.backup(number_to_keep: keep)
  end
end