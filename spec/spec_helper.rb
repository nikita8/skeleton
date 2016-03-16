# setup test environment
ENV['RACK_ENV'] = 'test'
Bundler.require(:default, :test)
require 'simplecov'
require 'rspec/core/rake_task'
require 'pry'
SimpleCov.start do
  add_filter '/spec/'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Consumers', 'app/consumers'
  add_group 'Configurations', 'config/'
end

require File.join(File.dirname(__FILE__), '..', 'app')

I18n.enforce_available_locales = false

FactoryGirl.definition_file_paths = %w( ./spec/factories )

FactoryGirl.find_definitions

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :rspec
  config.color = true
  config.formatter = 'documentation'
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.start
    redis.flushdb
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# helper method to make request specific calls
def make_api_call(request_type, route, params = {})
  http_verbs = %w(get post put delete)
  return {} unless http_verbs.include?(request_type)
  response = send(request_type, "#{route}.json", params)
  body = begin
    JSON.parse(response.body)
  rescue
    response.body
  end
  { headers: response.headers, body: body, code: response.status }
end

def app
  ApplicationModule::App
end
