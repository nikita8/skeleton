source 'https://rubygems.org'

ruby File.read('.ruby-version').match(/\S*/).to_s

gem 'activesupport-json_encoder', github: 'rails/activesupport-json_encoder'
gem 'api-pagination'

gem 'grape'
gem 'grape-activerecord'
gem 'grape-entity'

gem 'honeybadger'

gem 'httparty'
gem 'hutch'
gem 'sidekiq'

gem 'json'

gem 'kaminari', require: 'kaminari/grape'

gem 'newrelic-grape'
gem 'newrelic-redis'
gem 'newrelic_rpm'

gem 'pg'

gem 'rack'
gem 'rack-contrib'
gem 'rack-cors'
gem 'rack-utf8_sanitizer'
gem 'rake'
gem 'redis'

gem 'tux'

gem 'unicorn'

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-chruby', require: false
  gem 'grape_doc'
  gem 'hipchat'
  gem 'shotgun'
  gem 'thin'
end

group :development, :test do
  gem 'awesome_print'
  gem 'brakeman'
  gem 'colorize'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'faker'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
end

group :production do
end
