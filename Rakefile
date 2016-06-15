ENV['RACK_ENV'] ||= 'development'
env = ENV['RACK_ENV']

require 'rake'
require 'bundler'
Bundler.require(:default, env.to_sym)
require 'grape/activerecord/rake'
require File.expand_path('app', File.dirname(__FILE__))
Dir.glob('lib/tasks/*.rake').each { |f| load f }

desc 'API Routes'
task :routes do
  ApplicationModule::App.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path
    description = api.route_description
    puts "#{method} #{path} #{description}"
  end
end
