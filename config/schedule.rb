# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, '/path/to/my/cron_log.log'
#
# every 2.hours do
#   command '/usr/bin/some_great_command'
#   runner 'MyModel.some_method'
#   rake 'some:great:rake:task'
# end
#
# every 4.days do
#   runner 'AnotherModel.prune_old_records'
# end

# Learn more: http://github.com/javan/whenever

# 'Index All Items (from all collections) within two days'
every 1.day, at: '12am' do
  rake 'ingest:collections_daily'
end

# 'Clear cached record count totals'
every 1.day, at: '2:15am' do
  rake 'umedia_cache:clear_counts'
end

# 'Index Collection Metadata'
every 1.day, at: '2am' do
  rake 'ingest:collection_metadata'
end

# 'Enrich Primary Records with Child Page Transcripts'
every 1.day, at: '3am' do
  rake 'ingest:collection_transcripts_daily'
end

# 'Index Collection Metadata'
every 1.day, at: '4:00am' do
  rake 'solr:commit'
end

# 'Index Collection Metadata'
every 1.day, at: '4:15am' do
  rake 'solr:optimize'
end

# 'Backup Solr - Take a Snapshot'
every 1.month, at: '11pm' do
  rake 'solr:backup'
end
