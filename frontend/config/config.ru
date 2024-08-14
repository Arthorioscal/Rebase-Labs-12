require 'rack'
require 'rack/cors'
require_relative '../App'

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             headers: :any,
             methods: %i[get post options put delete]
  end
end

run App
