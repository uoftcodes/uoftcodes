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

    setup do
      ActionMailer::Base.deliveries.clear
    end
  end
end

require 'capybara/rails'
Capybara.register_driver :selenium_remote_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://localhost:4445/wd/hub',
    desired_capabilities: :chrome
  )
end

Capybara.register_driver :selenium_chrome_ci do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: 'http://localhost:4445/wd/hub',
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[headless disable-gpu] }
    )
  )
end
Capybara.javascript_driver = ENV['CI_SUITE'] ? :selenium_chrome_ci : :selenium_remote_chrome
