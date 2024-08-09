require 'sinatra/base'
require 'pg'

class Controller < Sinatra::Base
  def db_connection
    PG.connect(
      host: ENV['DATABASE_HOST'],
      user: ENV['DATABASE_USER'],
      password: ENV['DATABASE_PASSWORD'],
      dbname: ENV['DATABASE_NAME']
    )
  end

  get '/' do
    'Hello, world!'
  end

  get '/doctors' do
    conn = db_connection
    result = conn.exec('SELECT * FROM doctors')
    result.map { |row| row }.to_json
  end

  run! if app_file == $0
end