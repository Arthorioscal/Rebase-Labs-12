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

    result = if response.success?
               { message: 'Data imported successfully' }
             else
               { message: 'Failed to import data' }
             end

    puts "Import response: #{result.to_json}" # Log the response for debugging
    result.to_json
  end

  get '/' do
    content_type :html
    File.read(File.join('public', 'views', 'index.html'))
  end
end
