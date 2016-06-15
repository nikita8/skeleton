# Framework agnostic way to call the environment
env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

# enable out of band gc out of the box, it is low risk and improves perf a lot
# This is not necessary for ruby > 2.2
ENV['UNICORN_ENABLE_OOBGC'] ||= '1'

if env == 'development'
  wd = shared_path = app_path = File.expand_path('../../', __FILE__)
  tmp_path = "#{app_path}/tmp"
  total_processes = 1
  pid_file = "#{tmp_path}/unicorn.pid"
  socket_file = "#{tmp_path}/unicorn.sock"
else
  # relative path from unicorn.rb file
  app_path = File.expand_path('../../../..', __FILE__)
  shared_path = "#{app_path}/shared"
  wd = "#{app_path}/current"

  # We want minimum numbers of workers and
  # the ability to increase workers without deployments.
  # Machine time should determine the number of workers anyway !!!!
  total_processes = (ENV['UNICORN_WORKERS'] || 2).to_i
  pid_file = "#{shared_path}/tmp/pids/unicorn.pid"
  socket_file = "#{shared_path}/tmp/sockets/unicorn.sock"
end

# initialize unicorn variables
worker_processes total_processes
working_directory wd
pid pid_file

# listen
listen (ENV['UNICORN_PORT'] || socket_file), backlog: 64

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# By default, the Unicorn logger will write to stderr.
# Additionally, some applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

# important for Ruby 2.0
preload_app true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{wd}/Gemfile"
end
initialized = false
before_fork do |server, worker|
  unless initialized

    # get rid of rubbish so we don't share it
    GC.start

    initialized = true

  end

  # replace workers one at a time :) , memory-friendly
  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      File.open(stderr_path, 'a+') do |file|
        file.puts 'Exception occured while trying to kill old unicorn process'
      end
    end
  end

  # we gonna reconnect in childs
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # if redis-rb is used, it connects on demand.
  # So the master never opens up a socket
  # $redis.client.disconnect

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 2
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
