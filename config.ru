require File.expand_path('../app', __FILE__)
require File.expand_path('../lib/app_logger', __FILE__)

logger = AppLogger.logger
use Middleware::JsonLogger, logger
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use Rack::UTF8Sanitizer
run ApplicationModule::APP
