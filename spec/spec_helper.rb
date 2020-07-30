# frozen_string_literal: true

require 'bundler/setup'
require 'webmock/rspec'
require 'pry' unless ENV['CI']

# JRuby seems to report incorrect, lower stats.
unless RUBY_ENGINE == 'jruby'
  require 'simplecov'

  SimpleCov.start do
    minimum_coverage 95
    maximum_coverage_drop 1
    add_filter(/spec|refinements/)
  end
end

# This needs to come after requiring SimpleCov.
require 'cloudimage'

Dir["#{__dir__}/helpers/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.include SpecHelpers::FileHelpers
  config.include SpecHelpers::InvalidationHelpers

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
