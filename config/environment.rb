root_path = File.expand_path('../..', __FILE__)
ENV['RACK_ENV'] ||= 'development'
env = ENV['RACK_ENV']
Bundler.require(:default, env.to_sym)

require File.expand_path("#{root_path}/config/environments/#{env}.rb", __FILE__)
Dir[File.join(root_path, 'config', 'initializers', '**', '*.rb')].each { |f| require f }
Dir[File.join(root_path, 'lib', '*.rb')].each { |f| require f }
Dir[File.join(root_path, 'app', 'controllers', 'api', '**', '*.rb')].each do|f|
  require f
end
Dir[File.join(root_path, 'app', 'models', '*.rb')].each { |f| require f }
