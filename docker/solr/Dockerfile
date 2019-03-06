FROM  solr:7.3.0
LABEL maintainer="dls@umn.edu"

RUN mkdir -p /opt/solr/server/solr/cores/core/conf; \
echo 'name=core' > /opt/solr/server/solr/cores/core/core.properties; \
curl -Lo conf.tar.gz 'https://github.com/UMNLibraries/umedia_solr_conf/archive/v0.1.0.tar.gz'; \
tar -xzvf conf.tar.gz -C ./server/solr/cores/core/conf --strip-components 1; \