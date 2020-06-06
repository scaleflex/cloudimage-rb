# frozen_string_literal: true

require_relative 'params'
require_relative 'custom_helpers'

module Cloudimage
  class URI
    include Params
    include CustomHelpers

    attr_reader :uri, :params

    def initialize(base_url, path)
      path = ensure_path_format(path)
      @uri = Addressable::URI.parse(base_url + path)
      @params = {}
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

    def to_url(extra_params = {})
      url_params = params.merge(extra_params)
      uri.query_values = url_params if url_params.any?
      uri.to_s
    end

    private

    def ensure_path_format(path)
      path.start_with?('/') ? path : "/#{path}"
    end
  end
end
