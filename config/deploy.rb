set :application, 'app_name'
set :repo_url, 'github_repo'

# env configs
set :rack_env, fetch(:stage)
set :rails_env, fetch(:stage)
set :env, (fetch(:rails_env) || fetch(:stage))
set :honeybadger_env, (fetch(:rails_env) || fetch(:stage))

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/#{fetch(:application)}"

set :user, 'deploy'
set :ssh_options,
    user: 'deploy',
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    port: 2020,
    auth_methods: %w(publickey)

# Set New Relic user to git user name if it's set
`git config user.name`.strip.tap do |gituser|
  set :newrelic_user, gituser unless gituser.empty?
end

# Default value for :linked_files is [] # FIXME: later
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
linked_directory = %w(bin log tmp/pids tmp/sockets vendor/bundle public/assets)
set :linked_dirs, linked_directory

# Default value for keep_releases is 5
set :keep_releases, 3

# we would be securing /tmp on future
set :tmp_dir, "/home/#{fetch(:user)}"

# chruby, our dear ruby manager
# Defaults to: 'default'
set :chruby_ruby, File.read('.ruby-version').match(/\S*/).to_s

set :chruby_map_bins, fetch(:chruby_map_bins, []).concat(%w(unicorn honeybadger))

# capistrano-bundler
# By default, the plugin adds bundle exec prefix to common executables listed in
# bundle_bins option. This currently applies for gem, rake and rails.
# You can add any custom executable to this list:
set :bundle_bins, fetch(:bundle_bins, []).concat(%w(unicorn))

set :bundle_binstubs, nil
set :bundle_gemfile, -> { release_path.join('Gemfile') } # default: nil
set :bundle_path, nil
set :bundle_without, %w(development test darwin).join(' ')
# default: '--deployment --quiet'
set :bundle_flags, '--frozen --quiet'
# This is only available for bundler 1.4+
set :bundle_jobs, 2

# unicorn configs needed for restart
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:upgrade'
    end
  end

  task :migrate do
    # nothing to do here
  end
  after :publishing, :restart
end

if %w(production staging).include?(ARGV.first)
  # after 'deploy:restart', 'newrelic:notice_deployment'
end
