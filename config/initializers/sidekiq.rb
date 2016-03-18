sidekiq_config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
sidekiq_db = sidekiq_config['db'] || 0

Sidekiq.configure_server do |config|
  Hutch.connect(enable_http_api_use: false)
  config.redis = { url: "redis://#{sidekiq_config['sidekiq_host'] || sidekiq_config['host'] }:#{sidekiq_config['port']}/#{sidekiq_db}", namespace: 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{sidekiq_config['sidekiq_host'] || sidekiq_config['host']}:#{sidekiq_config['port']}/#{sidekiq_db}", namespace: 'sidekiq', size: 1 }
end

Sidekiq.default_worker_options = { 'queue' => 'default', 'backtrace' => true, 'retry' => 3 }
