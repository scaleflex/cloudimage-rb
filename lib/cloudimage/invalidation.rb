# frozen_string_literal: true

require 'net/http'
require 'json'

module Cloudimage
  module Invalidation
    ENDPOINT = ::URI.parse('https://api.cloudimage.com/invalidate')

    %i[original urls all].each do |type|
      define_method "invalidate_#{type}" do |*paths|
        validate_api_key

        body = {
          scope: type,
        }

        body[:urls] = paths if paths.any?

        send_request(body)
      end
    end

    private

    def validate_api_key
      return if config[:api_key]

      raise InvalidConfig, 'API key is required to perform cache invalidation.'
    end

    def headers
      {
        'X-Client-Key': config[:api_key],
        'Content-Type': 'application/json',
      }
    end

    def send_request(body)
      http = Net::HTTP.new(ENDPOINT.host, ENDPOINT.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(ENDPOINT.path, headers)
      request.body = body.to_json

      http.request(request)
    end
  end
end
