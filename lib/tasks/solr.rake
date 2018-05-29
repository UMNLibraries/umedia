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
end
