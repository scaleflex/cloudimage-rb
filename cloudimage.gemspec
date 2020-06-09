# frozen_string_literal: true

require_relative 'lib/cloudimage/version'

Gem::Specification.new do |s|
  s.name = 'cloudimage'
  s.version = Cloudimage::VERSION
  s.authors = ['Jan Klimo']
  s.email = ['jan.klimo@gmail.com']
  s.summary = "Official API wrapper for Cloudimage's API."
  s.description = 'Fast and easy image resizing, transformation, and acceleration in the Cloud.'

  s.homepage = 'https://github.com/scaleflex/cloudimage-rb'
  s.files = `git ls-files -- bin lib`.split("\n") + %w[CHANGELOG.md LICENSE README.md]

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/scaleflex/cloudimage-rb/issues',
    'changelog_uri' => 'https://github.com/scaleflex/cloudimage-rb/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/scaleflex/cloudimage-rb',
    'documentation_uri' => 'https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/introduction',
  }

  s.license = 'MIT'
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  s.add_dependency 'addressable', '~> 2.7'
end
