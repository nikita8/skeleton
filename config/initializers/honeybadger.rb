# frozen_string_literal: true
require 'honeybadger'

module HoneybadgerConfiguration
  # Honeybadger Configuration Connector
  class Connector
    def self.establish_connection
      @honeybadger_config ||= Honeybadger::Config.new(env: ENV['RACK_ENV'])
    end
  end
end

Honeybadger.start(HoneybadgerConfiguration::Connector.establish_connection)
