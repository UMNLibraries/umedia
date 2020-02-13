#!/bin/bash

./docker-compose-test-exec app bundle exec rake solr:restore
docker-compose exec app bundle exec rake solr:restore