require 'sidekiq'
require 'sidekiq/web'
require 'rack/cors'
require 'redis'
require 'connection_pool'
require_relative '../app/controllers/controller'

# Sidekiq configuration
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

# Redis
$redis = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(url: ENV['REDIS_URL'] || 'redis://redis:6379/0')
end
