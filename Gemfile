# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use Puma as the app server
gem 'puma', '>= 4.3.5'
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
gem 'bootsnap', '>= 1.1.0', require: false

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
  gem 'minitest-spec-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and
  # get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

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