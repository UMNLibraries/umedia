#!/bin/bash

echo  "Runing this script with remove and replace your current solr dev and test instances."
echo  "Run 'rake solr:backup' if you have a current working dev instance that you would like to retain."
read -p "Are you sure? [y|n]" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
  TEST_SNAPSHOT=snapshot.20190627191328762

  docker-compose stop
  docker-compose rm -fv solr;
  docker-compose rm -fv solr_test;

  # BUILD the local solr core
  git clone https://github.com/UMNLibraries/umedia_solr_conf.git;
  (cd umedia_solr_conf; ./rebuild.sh);

  # BUILD the App
  cp -n .env.example .env # n = "no clobber: don't overwrite if already there"
  docker-compose build;
  (docker-compose run app yarn install)
  echo "sudo chown -R $(whoami):$(whoami) node_modules"
  sudo chown -R $(whoami):$(whoami) node_modules

  # Before populating the indexes, we need to remove the old ones with possible
  # references to previous builds of the solr containers;


  # POPULATE the dev index
  mkdir -p snapshots;
  chmod 777 -R snapshots;
  (cd snapshots; curl -O "https://umedia-solr-test-cores.s3.amazonaws.com/$TEST_SNAPSHOT.tar.gz")
  (cd snapshots; tar -xzvf "$TEST_SNAPSHOT.tar.gz")
  docker-compose run app rake solr:restore

  # POPULATE the test index
  mkdir -p snapshots_test;
  chmod 777 -R snapshots_test
  (cd snapshots_test; curl -O "https://umedia-solr-test-cores.s3.amazonaws.com/$TEST_SNAPSHOT.tar.gz")
  (cd snapshots_test; tar -xzvf "$TEST_SNAPSHOT.tar.gz")
  ./docker-compose-test-run app rake solr:restore

  #START the app
  docker-compose up;
fi