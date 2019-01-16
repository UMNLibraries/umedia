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


#### CAPYBARA / SELENIUM
# Capybara config with docker-compose environment vars
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/minitest/spec'
Capybara.app_host = "http://#{ENV['TEST_APP_HOST']}:#{ENV['TEST_PORT']}"
Capybara.javascript_driver = :selenium
Capybara.run_server = false

# Configure the Chrome driver capabilities & register
args = ['--no-default-browser-check', '--start-maximized', '--disable-gpu']
caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => args})
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
      desired_capabilities: caps
  )
end

class ActiveSupport::TestCase
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
