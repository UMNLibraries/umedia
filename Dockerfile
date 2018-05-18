FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get update -qq && apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
RUN apt-get update -qq && apt-get install -y xvfb
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN mkdir /app
WORKDIR /app
ADD . /app
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without production