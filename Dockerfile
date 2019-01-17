# Stolen from https://github.com/jfroom/docker-compose-rails-selenium-example

FROM ruby:2.5.1

# Ugh, Yarn needs a newer version of Node
# See: https://github.com/yarnpkg/yarn/issues/6914#issuecomment-454165516
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs
# Rails 5.1 expects Yarn to be a thing
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install apt-transport-https -y
RUN apt-get update && apt-get install -y yarn


RUN mkdir -p /app
WORKDIR /app
COPY . .
# Add app files into docker image

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# Add bundle entry point to handle bundle cache

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
# Bundle installs with binstubs to our custom /bundle/bin volume path. Let system use those stubs.

