# frozen_string_literal: true

require_relative 'uri'

module Cloudimage
  class InvalidConfig < StandardError; end

  class Client
    attr_reader :token

    API_VERSION = 'v7'

    def initialize(token: nil)
      @token = token

      ensure_valid_config
    end

    def path(path)
      URI.new(base_url_for(token), path)
    end

    private

    def base_url_for(token)
      "https://#{token}.cloudimg.io/#{API_VERSION}"
    end

    def ensure_valid_config
      return unless token.to_s.strip.empty?

      raise InvalidConfig, 'Please specify your Cloudimage customer token.'
    end
  end
end
