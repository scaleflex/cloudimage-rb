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
      @config[:salt] = options[:salt]
      @config[:signature_length] =
        options[:signature_length] || DEFAULT_SIGNATURE_LENGTH
      @config[:api_version] = API_VERSION
      @config[:sign_urls] = options[:sign_urls].nil? ? true : false
      @config[:aliases] = options[:aliases] || {}

      ensure_valid_config
    end

    def path(path)
      URI.new(path, **config)
    end

    private

    def ensure_valid_config
      ensure_valid_token
      ensure_valid_signature_length
    end

    def ensure_valid_token
      return unless config[:token].nil?

      raise InvalidConfig, 'Please specify your Cloudimage customer token.'
    end

    def ensure_valid_signature_length
      return if config[:salt].nil?
      return if (6..40).cover? config[:signature_length]

      raise InvalidConfig, 'Signature length must be must be 6-40 characters.'
    end
  end
end
