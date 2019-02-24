FROM  solr:7.3.0
LABEL maintainer="dls@umn.edu"

RUN mkdir -p /opt/solr/server/solr/cores/core/conf
RUN touch /opt/solr/server/solr/cores/core/conf/core.properties
RUN echo 'name=core' > /opt/solr/server/solr/cores/core/core.properties
RUN curl -Lo conf.tar.gz 'https://github.com/UMNLibraries/umedia_solr_conf/archive/v0.1.0.tar.gz'
RUN tar -xzvf conf.tar.gz -C ./server/solr/cores/core/conf --strip-components 1