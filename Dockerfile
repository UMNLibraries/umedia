FROM ruby:2.6 AS production

LABEL maintainer="libwebdev@umn.edu"
LABEL org.opencontainers.image.source=https://github.com/UMNLibraries/umedia

SHELL ["/bin/bash", "-c"]
ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# this value is good enough for build time, but needs to be fixed at runtime
ENV UMEDIA_NAILER_CDN_URI=https://example.cloudfront.net

# we need this for newer versions of NodeJS to work with our older library choices
ENV NODE_OPTIONS="--openssl-legacy-provider"

# make Yarn a little less chatty
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# set up system
RUN <<EOF
# install package dependencies
apt update --quiet
apt install -y less neovim

# create the deploy and runtime users
useradd uldeploy --uid 30000 --user-group --no-create-home
mkdir -p /srv/umedia
useradd ulapps --uid 40000 --user-group --home-dir /srv/umedia
EOF

# Install application files
WORKDIR /srv/umedia
COPY --chown=uldeploy:uldeploy . .

# install dependencies
RUN <<EOF

# ruby
gem update --system 3.2.3
gem install bundler -v 2.4.22
bundle check || bundle install
bundle binstubs --all

# nodejs (v22.x)
curl -sL https://deb.nodesource.com/setup_22.x | bash
apt-get update
apt-get install -qq -y --no-install-recommends build-essential nodejs
corepack enable yarn
yarn install --production

# rails assets
rake assets:precompile
EOF

# set up image entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# USER ulapps:ulapps

