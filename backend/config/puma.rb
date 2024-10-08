workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      File.expand_path('config.ru', __dir__)
port        ENV.fetch('PORT', 4567)
environment ENV.fetch('RACK_ENV') { 'development' }