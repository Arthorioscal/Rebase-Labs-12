workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

port        ENV.fetch('PORT', 9292)
environment ENV.fetch('RACK_ENV') { 'development' }