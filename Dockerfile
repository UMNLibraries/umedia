FROM ghcr.io/umnlibraries/ruby2.6-jemalloc:0.0.6

LABEL maintainer="libwebdev@umn.edu" \
      org.opencontainers.image.source="https://github.com/UMNLibraries/umedia"

# Optimize jemalloc memory arena behavior for Ruby
ENV MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true"

#### Set your working directory and app configurations
###WORKDIR /app


SHELL ["/bin/bash", "-c"]

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_LOG_TO_STDOUT=true

# this value is good enough for build time, but needs to be fixed at runtime
ENV UMEDIA_NAILER_CDN_URI=https://example.cloudfront.net

# we need this for newer versions of NodeJS to work with our older library choices
ENV NODE_OPTIONS="--openssl-legacy-provider"

# make Yarn a little less chatty
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# create the deploy user
RUN <<__uldeploy__
groupadd --gid 30000 uldeploy
useradd --uid 30000 --gid 30000 --no-create-home uldeploy
__uldeploy__

# create the runtime user
RUN <<__ulapps__
mkdir -p /srv/umedia
groupadd --gid 40000 ulapps
useradd --uid 40000 --gid 40000 --home-dir /srv/umedia ulapps
__ulapps__

# Install application files
WORKDIR /srv/umedia
COPY --chown=30000:30000 . .

# install ruby dependencies
RUN <<__ruby__
gem update --system 3.2.3 --quiet
gem install bundler -v 2.4.22
bundle check || bundle install
bundle binstubs --all
__ruby__

# install node and yarn dependencies
RUN <<__node__
apt update
apt upgrade -y
apt install -y --no-install-recommends build-essential curl nodejs
curl -sL https://deb.nodesource.com/setup_22.x | bash
corepack enable yarn
yarn install --production

corepack enable yarn
yarn install --production
__node__

# compile rails assets
RUN <<__rake__
rake assets:precompile
__rake__

# set up image entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
USER ulapps:ulapps
ENTRYPOINT ["/docker-entrypoint.sh"]
