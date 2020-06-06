# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'cloudimage'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
