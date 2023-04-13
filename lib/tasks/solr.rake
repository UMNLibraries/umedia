namespace :solr do
  desc "commit changes"
  task commit: [:environment] do
    SolrClient.new.commit
  end

  desc "optimize core"
  task optimize: [:environment] do
    SolrClient.new.optimize
  end

  desc "delete core index"
  task delete_index: [:environment] do
    SolrClient.new.delete_index
  end

  desc "backup solr data locally"
  task :backup, [:backup_name] => :environment do |_t, args|
    SolrClient.new.backup(number_to_keep: 5, backup_name: args[:backup_name])
  end

  desc "Restore latest backup"
  task :restore, [:backup_name] => :environment do |_t, args|
    SolrClient.new.restore(backup_name: args[:backup_name])
  end
end
