#!/bin/bash
podman-compose exec app bundle exec rake solr:backup; chmod -R 777 snapshots; cp -r snapshots/* snapshots_test; ./podman-compose-test-exec app bundle exec rake solr:restore
