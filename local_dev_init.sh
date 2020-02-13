#!/bin/bash

echo  "Runing this script with remove and replace your current solr dev and test instances."
echo  "Run 'rake solr:backup' if you have a current working dev instance that you would like to retain."
read -p "Are you sure? [y|n]" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
  docker-compose stop

  # BUILD the local solr core
  git clone https://github.com/UMNLibraries/umedia_solr_conf.git;
  (cd umedia_solr_conf; ./rebuild-dev.sh; ./rebuild-test.sh);

  # BUILD the App
  cp -n .env.example .env # n = "no clobber: don't overwrite if already there"
  docker-compose build;
  (docker-compose run app yarn install)
  echo "sudo chown -R $(whoami):$(whoami) node_modules"
  sudo chown -R $(whoami):$(whoami) node_modules


  # Create the snapshot directories
  mkdir -p snapshots;
  cp -R snapshots_test/* snapshots
fi