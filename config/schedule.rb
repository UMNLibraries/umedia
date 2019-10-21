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

# 'Index All Items (from all collections)'
every :saturday, at: '8pm' do
  rake 'ingest:collections'
end

# 'Index Collection Metadata'
every :monday, at: '12am' do
  rake 'ingest:collection_metadata'
end

# 'Enrich Primary Records with Child Page Transcripts'
every :monday, at: '1am' do
  rake 'ingest:all_collection_transcripts'
end

# 'Index Collection Metadata'
every 1.day, at: '12:00am' do
  rake 'solr:commit'
end

# 'Index Collection Metadata'
every 1.day, at: '12:30am' do
  rake 'solr:optimize'
end

# 'Backup Solr - Take a Snapshot'
every 1.month, at: '12am' do
  rake 'solr:backup'
end
