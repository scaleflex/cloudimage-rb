# frozen_string_literal: true

require 'digest'
require 'base64'

require_relative 'refinements'

module Cloudimage
  class Security
    using Refinements

    attr_reader :uri, :config

    def initialize(uri, **config)
      @uri = uri
      @config = config
    end

    def sign_url(request_uri)
      query = uri.query_values || {}
      uri.query_values = query.merge(ci_sign: signature(request_uri))
    end

    def seal_url(path, sealed_params)
      query = uri.query_values || {}
      sealed_query = query.slice(*sealed_params)
      query.keep_if { |k, _| !sealed_query.key?(k) }
      eqs = eqs(sealed_query)
      query[:ci_eqs] = eqs unless eqs.empty?
      query[:ci_seal] = seal(path, eqs)
      uri.query_values = query
    end

    private

    def signature(request_uri)
      digest = Digest::SHA1.hexdigest(config[:salt] + request_uri)
      trim(digest, config[:signature_length])
    end

    def eqs(query_params)
      uri = Addressable::URI.new
      uri.query_values = query_params
      Base64.urlsafe_encode64(uri.query, padding: false)
    end

    def seal(path, eqs)
      digest = Digest::SHA1.hexdigest(path + eqs + config[:salt])
      trim(digest, config[:signature_length])
    end

    def trim(signature, length)
      signature[0, length]
    end
  end
end
