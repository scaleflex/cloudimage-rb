# frozen_string_literal: true

require_relative 'uri'

module Cloudimage
  class InvalidConfig < StandardError; end

  class Client
    attr_reader :config

    API_VERSION = 'v7'
    DEFAULT_SIGNATURE_LENGTH = 18

    def initialize(**options)
      @config = {}
      @config[:token] = options[:token]
      @config[:cname] = options[:cname]
      @config[:salt] = options[:salt]
      @config[:signature_length] =
        options[:signature_length] || DEFAULT_SIGNATURE_LENGTH
      @config[:api_version] = API_VERSION
      @config[:sign_urls] = options[:sign_urls].nil? ? true : false
      @config[:aliases] = options[:aliases] || {}

      assert_valid_config
    end

    def path(path)
      URI.new(path, **config)
    end

    private

    def assert_valid_config
      assert_token_or_cname
      assert_valid_signature_length
    end

    def assert_token_or_cname
      return unless config[:token].nil? && config[:cname].nil?

      raise InvalidConfig,
            'Please specify your customer token or a custom CNAME.'
    end

    def assert_valid_signature_length
      return if config[:salt].nil?
      return if (6..40).cover? config[:signature_length]

      raise InvalidConfig, 'Signature length must be must be 6-40 characters.'
    end
  end
end
