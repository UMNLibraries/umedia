#!/bin/bash
# Create a snapshot of the dev index at snapshots/snapshot.umedia_dev_snap
# Copy it to snapshots_test
# Restore it into the test index to keep in sync with dev
#
# THIS IS ONLY NEEDED WHEN YOU ADD NEW TEST RECORDS
docker-compose exec app bundle exec rake solr:backup; \
  sudo chmod -R 777 "snapshots/$(ls -1t snapshots|head -n1)"; \
  git rm -r snapshots_test/umedia_dev_snap && cp -r snapshots/$(ls -1t snapshots|head -n1) snapshots_test/snapshot.umedia_dev_snap; \
  ./docker-compose-test-exec app bundle exec rake solr:restore[umedia_dev_snap]
