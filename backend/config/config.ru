require 'sidekiq/web'
require 'rack/session'
require 'securerandom'
require_relative 'initializer'

secret_key = SecureRandom.hex(32)
use Rack::Session::Cookie, secret: secret_key, same_site: true, max_age: 86_400

map '/sidekiq' do
  run Sidekiq::Web
end

run Controller
