#!/bin/bash
docker-compose exec app rake solr:backup; sudo chmod -R 777 snapshots; cp -r snapshots/* snapshots_test; ./docker-compose-test-exec app rake solr:restore