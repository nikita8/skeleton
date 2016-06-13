# frozen_string_literal: true
require 'faraday'

def http_client
  @http_client ||= Faraday.new do |faraday|
    faraday.request :url_encoded
    faraday.headers['Content-Type'] = 'application/json'
    faraday.adapter  Faraday.default_adapter
    faraday.options.timeout = 60 # open/read timeout in seconds
  end
end
