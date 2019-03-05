# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :saturday, at: '8pm' do
  runner "Index All Items (from all collections)"
  rake 'ingest:collections'
end

every :sunday, at: '8pm' do
  runner "Index Collection Metadata"
  rake 'ingest:collection_metadata'
end

every 1.day, at: '12:00am' do
  runner "Index Collection Metadata"
  rake 'solr:commit'
end

every 1.day, at: '12:30am' do
  runner "Index Collection Metadata"
  rake 'solr:optimize'
end