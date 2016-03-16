config_hash = YAML.load_file('config/app.yml')[ENV['RACK_ENV']]
APP_CONFIG = OpenStruct.new(config_hash)
