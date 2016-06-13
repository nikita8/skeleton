require File.expand_path('../app', __FILE__)
require File.expand_path('../lib/app_logger', __FILE__)

logger = AppLogger.logger
use Middleware::JsonLogger, logger
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use Rack::UTF8Sanitizer
honeybadger_config = HoneybadgerConfiguration::Connector.establish_connection
use Honeybadger::Rack::ErrorNotifier, honeybadger_config
use Honeybadger::Rack::MetricsReporter, honeybadger_config

run ApplicationModule::APP

map '/sidekiq' do
  run Sidekiq::Web
end
