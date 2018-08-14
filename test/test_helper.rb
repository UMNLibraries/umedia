ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/autorun"
require 'webmock/minitest'

WebMock.enable!

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
end
