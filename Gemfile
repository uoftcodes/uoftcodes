# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.5.0'
gem 'jbuilder', '~> 2.5'
gem 'pg', '~> 0.18.4'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'rails_admin', '~> 1.4.2'
gem 'redis', '~> 4.0.2'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq', '~> 5.2.2'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

group :production do
  gem 'timber', '~> 2.6'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
