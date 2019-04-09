FROM ruby:2.6.1
LABEL maintainer="dls@umn.edu"

# Ugh, Yarn needs a newer version of Node
# See: https://github.com/yarnpkg/yarn/issues/6914#issuecomment-454165516
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs \
    # Rails 5.1 expects Yarn to be a thing \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get install apt-transport-https -y \
    && apt-get update && apt-get install -y yarn

ENV APP_DIR /app
RUN mkdir -p $APP_DIR; \
    curl -Lo app.tar.gz 'https://github.com/UMNLibraries/umedia/archive/v0.2.0.tar.gz'; \
    tar -xzvf app.tar.gz -C ./app --strip-components 1

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR $APP_DIR
RUN gem update --system ; gem install bundler
RUN bundle check || bundle install

# Requires by content security policy, which is called durint asset precompile (below)
ENV UMEDIA_NAILER_CDN_URI https://d2y23onbq5rnfc.cloudfront.net
RUN yarn install --check-files; bin/rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]