sidekiq_config = YAML.load(
  File.open("#{App.root}/config/redis.yml")
)[ENV['RACK_ENV']]
sidekiq_db = sidekiq_config['db'] || 0
sidekiq_host = sidekiq_config['host']
sidekiq_port = sidekiq_config['port']
sidekiq_url = "#{sidekiq_host}:#{sidekiq_port}/#{sidekiq_db}"
Sidekiq.configure_server do |config|
  Hutch.connect(enable_http_api_use: false)
  config.redis = { url: sidekiq_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_url, size: 1 }
end

Sidekiq.default_worker_options = { queue: :default, backtrace: true, retry: 3 }
