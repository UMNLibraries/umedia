# Stolen from https://github.com/jfroom/docker-compose-rails-selenium-example

FROM ruby:2.6 AS development
LABEL maintainer="libwebdev@umn.edu"

#ARG ENVIRONMENT=production
ARG ENVIRONMENT=development
ENV RAILS_ENV=$ENVIRONMENT
ENV NODE_ENV=$ENVIRONMENT

# create the deploy and runtime users
RUN <<EOF
useradd uldeploy --uid 30000 --user-group --no-create-home
mkdir -p /srv/umedia
useradd ulapps --uid 40000 --user-group --home-dir /srv/umedia
EOF

# Install application files
WORKDIR /srv/umedia
COPY --chown=uldeploy:uldeploy . .

# install Ruby dependencies
RUN <<EOF
gem update --system 3.2.3
gem install bundler -v 2.4.22
bundle check || bundle install
EOF

# install nodejs (v22.x) dependencies
RUN <<EOF
curl -sL https://deb.nodesource.com/setup_22.x | bash
apt-get update
apt-get install -qq -y --no-install-recommends build-essential nodejs
corepack enable yarn
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 yarn install --production
EOF

#RUN "rake assets:precompile --trace"

# set up image entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# USER ulapps:ulapps
