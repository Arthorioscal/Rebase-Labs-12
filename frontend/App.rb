require 'sinatra/base'
require 'json'
require 'faraday'
require 'faraday/multipart'

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
  
    if params[:file] && params[:file][:tempfile]
      file = params[:file][:tempfile]
      filename = params[:file][:filename]
      file_type = params[:file][:type]
  
      unless file_type == 'text/csv'
        status 400
        return { message: 'Tipo de arquivo inválido. Apenas arquivos CSV são permitidos.' }.to_json
      end
  
      backend_url = ENV['BACKEND_URL'] || 'http://localhost:4567'
  
      conn = Faraday.new do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
  
      payload = {
        file: Faraday::Multipart::FilePart.new(file, 'text/csv', filename)
      }
  
      response = conn.post("#{backend_url}/import", payload)
  
      result = if response.success?
                 { message: 'Importando Dados, aguarde um momento.' }
               else
                 { message: 'Erro ao importar dados.' }
               end
  
      result.to_json
    else
      status 400
      { message: 'Nenhum arquivo foi enviado.' }.to_json
    end
  end

  get '/' do
    content_type 'text/html'
    erb :'index.html', layout: :'layouts/application.html'
  end
end
