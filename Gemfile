# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.8.1'
# Use Puma as the app server
gem 'puma', '~> 5.6.9'
# Run puma with systemd integration
gem 'sd_notify', '>= 0.1.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant

# Reduces boot times through caching; required in config/boot.rb
# Disabled bootsnap, problematic on rails 5.2.6
#gem 'bootsnap', '>= 1.16.0', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'brakeman'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Deployment
  gem 'capistrano'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'simplecov'
  # Something weird happened to mocking in 5.17
  gem 'minitest', '>= 5.1', '< 5.16.0'
  gem 'minitest-spec-rails'
  # To eliminate warnings of the form '...forwarding to private method Minitest::Mock#{method_name}'
  # See: https://github.com/freerange/mocha/issues/321
  gem 'mocha'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and
  # get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

gem 'dotenv-rails'
gem 'bootstrap-sass', '>=3.4.1'
gem 'cdmdexer', '>= 0.21.0'
gem 'fontello_rails_converter'
gem 'lograge'
gem 'mini_magick', '>= 4.9.4'
gem 'rinku'
gem 'rsolr'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'webpacker', '~> 5.x'
gem 'whenever', require: false
gem 'will_paginate'
gem 'loofah', '>= 2.3.1'
gem 'rack', '>= 2.0.8'
gem 'rubyzip', '>= 1.3.0'
# Allows us to delete thumbs
gem 'aws-sdk'
