require 'sinatra/base'
require 'json'
require 'faraday'

class App < Sinatra::Base
  get '/exams' do
    content_type :json

    backend_url = ENV['BACKEND_URL'] || 'http://localhost:4567'
    response = Faraday.get("#{backend_url}/tests")
    exams = JSON.parse(response.body)

    exams.to_json
  end

  get '/exams/:token' do
    content_type :json

    backend_url = ENV['BACKEND_URL'] || 'http://localhost:4567'
    response = Faraday.get("#{backend_url}/tests/#{params[:token]}")
    exam = JSON.parse(response.body)

    exam.to_json
  end

  post '/import' do
    content_type :json

    backend_url = ENV['BACKEND_URL'] || 'http://localhost:4567'
    response = Faraday.post("#{backend_url}/import")

    response.body.to_json
  end

  get '/' do
    content_type :html
    File.read(File.join('public', 'views', 'index.html'))
  end
end
