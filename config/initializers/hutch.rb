require 'hutch'
require File.expand_path(File.expand_path('../../../lib/app_logger', __FILE__))
# Hutch connection to rabbitmq-server wrapper
module Hutch
  module Connector
    module_function

    def establish_connection
      rabbitmq_config = config
      rabbitmq_config[:client_logger] = AppLogger.logger
      Hutch::Config.initialize(rabbitmq_config)
    end

    def config
      # assuming hutch config file in one dir up
      YAML.load_file(
        File.expand_path('../../rabbitmq.yml', __FILE__)
      )[ENV['RACK_ENV']]
    end
  end
end
Hutch::Connector.establish_connection
Hutch::Logging.logger = AppLogger.logger
