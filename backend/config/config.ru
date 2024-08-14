require 'sidekiq/web'
require 'rack/session'
require 'securerandom'
require_relative 'initializer'

secret_key = SecureRandom.hex(32)
use Rack::Session::Cookie, secret: secret_key, same_site: true, max_age: 86_400

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             headers: :any,
             methods: %i[get post options put delete]
  end
end

map '/sidekiq' do
  run Sidekiq::Web
end

run Controller
