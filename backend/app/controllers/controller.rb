require 'sinatra/base'
require 'pg'
require 'json'
require_relative '../../lib/db_connection'

class Controller < Sinatra::Application
  get '/' do
    'Hello, world!'
  end

  get '/tests' do
    conn = DatabaseConnection.db_connection
    tests = conn.exec('SELECT * FROM tests')
    tests.map { |test| test }.to_json
  end

  get '/doctors' do
    conn = DatabaseConnection.db_connection
    @doctors = conn.exec('SELECT * FROM doctors')
    erb :doctors
  end

  run! if app_file == $0
end