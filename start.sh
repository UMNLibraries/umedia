#!/bin/bash

# ARG: docker-commose --project => allows us to spin-up and tear down groups of containers
# By convention, we only have two rotating groups 0 and 1
# There are two solr cores, one for each group, cores-0 & cores-1. The core num is taken from the argument to this file.
# e.g.:
#
# docker_start.sh 0

CURRENT_UID="$(id -u)":"$(id -g)"
COMPOSE_OPTIONS="-e CURRENT_UID=$CURRENT_UID -e SOLR_CORE_NUM=$1" docker-compose -f docker-compose-prod.yml -p umedia_$1 up -d --no-deps --remove-orphans --force-recreate --scale app=4