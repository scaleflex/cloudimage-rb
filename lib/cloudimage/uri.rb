# frozen_string_literal: true

require 'digest'

require_relative 'params'
require_relative 'custom_helpers'

module Cloudimage
  class URI
    include Params
    include CustomHelpers

    attr_reader :uri, :params, :config

    def initialize(path, **config)
      @config = config
      @params = {}
      @uri = build_uri_from(path)
    end

    PARAMS.each do |param|
      define_method param do |*args|
        @params[param] = if args.any?
                           args.join(',')
                         else
                           # Flag params don't need to pass in arguments.
                           @params[param] = 1
                         end
        self
      end
    end

    ALIASES.each do |from, to|
      alias_method from, to
    end

    def to_url(**extra_params)
      set_uri_params(**extra_params)
      sign_url
    end

    private

    def base_url
      "https://#{config[:token]}.cloudimg.io"
    end

    def base_url_with_api_version
      "#{base_url}/#{config[:api_version]}"
    end

    def build_uri_from(path)
      formatted_path = path.start_with?('/') ? path : "/#{path}"
      Addressable::URI.parse(base_url_with_api_version + formatted_path)
    end

    def set_uri_params(**extra_params)
      url_params = params.merge(**extra_params)
      return unless url_params.any?

      uri.query_values = url_params
    end

    def sign_url
      url = uri.to_s

      return url if config[:salt].nil?

      url + "#{uri.query_values ? '&' : '?'}ci_sign=#{signature}"
    end

    def signature
      path = uri.to_s.sub(base_url_with_api_version, '')
      digest = Digest::SHA1.hexdigest(config[:salt] + path)
      digest[0..(config[:signature_length] - 1)]
    end
  end
end
