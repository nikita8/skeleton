# Rack middleware wrapper
module Middleware
  # Middleware class inherited from common logger
  # request logs are in json formatting
  class JsonLogger < Rack::CommonLogger
    def initialize(app, logger)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = Time.now.utc
      @app.call(env).tap do |status, header, _body|
        log(env, status, header, began_at)
      end
    end

    private

    def log(env, status, _header, began_at)
      msg = RequestLogFormatter.new(env, status, began_at).to_json
      logger = @logger || env['rack.errors']
      # Standard library logger doesn't support write
      # but it supports << which actually
      # calls to write on the log device without formatting
      logger.respond_to?(:write) ? logger.write(msg) : logger << msg
    end
  end

  # Formats request log from rack env to json
  class RequestLogFormatter
    def initialize(env, status, began_at)
      @env = env
      @began_at = began_at
      @status = status
    end

    def to_json
      "#{message.to_json}\n"
    end

    def message
      now = Time.now.utc
      {
        timestamp: now.strftime('%Y-%m-%dT%H:%M:%SZ'),
        method: env['REQUEST_METHOD'],
        location: location,
        params: (env['rack.request.form_hash'] || {}),
        status: status.to_s[0..3],
        duration: (now - began_at)
      }
    end

    private

    def location
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['PATH_INFO']}"
    end

    attr_accessor :env, :status, :began_at
  end
end
