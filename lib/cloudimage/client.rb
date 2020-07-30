# frozen_string_literal: true

require_relative 'uri'
require_relative 'invalidation'

module Cloudimage
  class InvalidConfig < StandardError; end

  class Client
    include Invalidation

    attr_reader :config

    API_VERSION = 'v7'
    DEFAULT_SIGNATURE_LENGTH = 18

    def initialize(**options)
      @config = set_config_defaults(options)
      validate_config
    end

    def path(path)
      URI.new(path, **config)
    end

    private

    def set_config_defaults(options)
      options.tap do |config|
        config[:signature_length] =
          options[:signature_length] || DEFAULT_SIGNATURE_LENGTH
        config[:api_version] = API_VERSION
        config[:sign_urls] = options[:sign_urls].nil? ? true : false
        config[:aliases] = options[:aliases] || {}
      end
    end

    def validate_config
      validate_site_config
      validate_signature_length
    end

    def validate_site_config
      return unless config[:token].nil? && config[:cname].nil?

      raise InvalidConfig,
            'Please specify your customer token or a custom CNAME.'
    end

    def validate_signature_length
      return if config[:salt].nil?
      return if (6..40).cover? config[:signature_length]

      raise InvalidConfig, 'Signature length must be must be 6-40 characters.'
    end
  end
end
