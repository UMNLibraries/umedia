#
# After modifing the 'sample-records.json', indexing the content, and syncing it to
# the test index, you will want to share this new test index by pushing it to dockerhub
# so that other developers and CI tools will have the most current test index.

docker-compose exec solr_test bash -c 'cp -R /opt/solr/server/solr/cores/core/conf/data/* /test_index'
rm -rf umedia_solr_conf/data;
cp -R test_index umedia_solr_conf/data;
rm umedia_solr_conf/data/restore*/write.lock;
(cd umedia_solr_conf; ./rebuild-test.sh);