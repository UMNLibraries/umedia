#!/bin/bash
# Create a snapshot of the dev index at snapshots/snapshot.umedia_dev_snap
# Copy it to snapshots_test
# Restore it into the test index to keep in sync with dev
#
# THIS IS ONLY NEEDED WHEN YOU ADD NEW TEST RECORDS
docker-compose exec app bundle exec rake solr:backup[umedia_dev_snap]; \
  sudo chmod -R 777 snapshots/snapshot.umedia_dev_snap; \
  cp -r snapshots/snapshot.umedia_dev_snap snapshots_test; \
  ./docker-compose-test-exec app bundle exec rake solr:restore[umedia_dev_snap]
