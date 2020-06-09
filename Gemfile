# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'pry'
gem 'rake'
gem 'rspec'

install_if -> { RUBY_VERSION !~ /^2\.3/ } do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
end
