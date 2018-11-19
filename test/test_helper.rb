# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include ActionMailer::TestHelper
    include FactoryBot::Syntax::Methods
    fixtures :all
  end
end
