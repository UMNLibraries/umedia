FROM ruby:2.6.1
LABEL maintainer="libwebdev@umn.edu"

# Stolen from https://github.com/jfroom/docker-compose-rails-selenium-example

# install Node v. 10, yarn (v1), and some python and cairo dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
  && apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential nodejs python python3 libpangocairo1.0-0 \
  # Rails 5.1 expects Yarn to be a thing \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get install apt-transport-https -y \
  && apt-get update && apt-get install -y yarn

RUN mkdir -p /app
WORKDIR /app
COPY . .
# Add app files into docker image

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN gem update --system ; gem install bundler
RUN bundle check || bundle install

