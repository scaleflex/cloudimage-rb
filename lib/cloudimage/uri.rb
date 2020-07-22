# frozen_string_literal: true

require 'set'

require_relative 'params'
require_relative 'custom_helpers'
require_relative 'security'
require_relative 'refinements'

module Cloudimage
  class URI
    using Refinements

    include Params
    include CustomHelpers

    attr_reader :path, :uri, :params, :config, :sealed_params

    def initialize(path, **config)
      @config = config
      @params = {}
      @sealed_params = Set.new
      @path = transform(path)
      @uri = build_uri
    end

    PARAMS.each do |param|
      define_method param do |*args|
        # Flag params don't need to pass in arguments.
        params[param] = args.any? ? args.join(',') : 1
        self
      end
    end

    ALIASES.each do |from, to|
      alias_method from, to
    end

    def to_url(**extra_params)
      set_uri_params(**extra_params)
      secure_url
      uri.to_s
    end

    private

    def site
      return "https://#{config[:cname]}" if config[:cname]

      "https://#{config[:token]}.cloudimg.io"
    end

    def api_version
      "/#{config[:api_version]}"
    end

    def transform(path)
      path
        .then { |input| input.start_with?('/') ? input : "/#{input}" }
        .then(&method(:apply_aliases))
    end

    def apply_aliases(path)
      return path if config[:aliases].empty?

      path.dup.tap do |input|
        config[:aliases].each do |source, target|
          input.gsub!(source, target)
        end
      end
    end

    def request_uri
      uri.request_uri.delete_prefix(api_version)
    end

    def build_uri
      Addressable::URI.parse(site + api_version + path)
    end

    def set_uri_params(**extra_params)
      seal_params(*extra_params.delete(:seal_params))
      url_params = params.merge(**extra_params)
      return unless url_params.any?

      uri.query_values = url_params
    end

    def secure_url
      return uri.to_s if config[:salt].nil?

      security = Security.new(uri, **config)

      if config[:sign_urls]
        security.sign_url(request_uri)
      else
        security.seal_url(path, sealed_params)
      end
    end
  end
end
