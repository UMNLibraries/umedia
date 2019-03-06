#!/bin/bash

docker-compose exec -e "RAILS_ENV=test" -e "SOLR_URL=http://solr_test:8983/solr/core" app rake solr:restore