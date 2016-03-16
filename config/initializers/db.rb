require 'active_record'
require File.expand_path(File.expand_path('../../../lib/app_logger', __FILE__))

module DB
  # :nodoc:
  module Connector
    extends self

    def establish_connection
      ActiveRecord::Base.establish_connection(config)
    end

    def config
      config_file_path = File.join(File.expand_path('../..', __FILE__), 'database.yml')
      YAML.load_file(config_file_path)[ENV['RACK_ENV'] || 'development']
    end
  end
end

DB::Connector.establish_connection
ActiveRecord::Base.logger = AppLogger.logger
