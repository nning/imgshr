ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/spec'
require 'capybara/rails'

require 'coveralls'
Coveralls.wear!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

Capybara.javascript_driver = :webkit

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

def emsi
  f = open(Rails.root.join('public', 'images', 'emsi.png'))
  f.seek(0)
  f
end

def avenger
  f = open(Rails.root.join('test', 'fixtures', 'avenger.jpg'))
  f.seek(0)
  f
end
