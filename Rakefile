# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

unless ENV['CI']
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.user = 'scaleflex'
    config.project = 'cloudimage-rb'
    config.since_tag = 'v0.2.1'
    config.issues = false
  end
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
