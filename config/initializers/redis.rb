file_path = File.expand_path('../../config/redis.yml', File.dirname(__FILE__))
REDIS_CONFIG = YAML.load_file(file_path)[(ENV['RACK_ENV'])].with_indifferent_access

def redis
  @redis ||= Redis.new(
    host: REDIS_CONFIG['host'],
    port: REDIS_CONFIG['port'],
    db: REDIS_CONFIG['db'])
end
