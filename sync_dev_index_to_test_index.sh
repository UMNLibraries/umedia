#!/bin/bash
docker-compose exec app bundle exec rake solr:backup; sudo chmod -R 777 snapshots; cp -r snapshots/* snapshots_test; ./docker-compose-test-exec app bundle exec rake solr:restore
