#!/bin/bash

./podman-compose-test-exec app bundle exec rake solr:restore
podman-compose exec app bundle exec rake solr:restore
