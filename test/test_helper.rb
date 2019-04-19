# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_group 'Policies', 'app/policies'
  add_group 'Presenters', 'app/presenters'
  add_group 'Serializers', 'app/serializers'
  add_group 'Validators', 'app/validators'
end

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/reporters'

mean_time_reporter_options = {
  previous_runs_filename: Rails.root.join('tmp', 'minitest_reporters_previous_run'),
  report_filename: Rails.root.join('tmp', 'minitest_reporters_report')
}

Minitest::Reporters.use! Minitest::Reporters::MeanTimeReporter.new(mean_time_reporter_options)

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
    #
    # Note: You'll currently still have to declare fixtures explicitly in integration tests
    # -- they do not yet inherit this setting
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end
