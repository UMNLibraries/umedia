ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# Bootsnap has been problematic on rails >5.2.6 for UMedia. disabled because we don't need it *that* much
#require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
