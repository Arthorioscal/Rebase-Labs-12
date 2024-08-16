require 'sinatra/base'
require 'json'
require 'faraday'
require 'faraday/multipart'

class App < Sinatra::Base
  helpers do
    def backend_url
      ENV['BACKEND_URL'] || 'http://localhost:4567'
    end

    def faraday_connection
      Faraday.new do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
    end

    def validate_file_upload
      if params[:file] && params[:file][:tempfile]
        file = params[:file][:tempfile]
        file_type = params[:file][:type]

        if file_type == 'text/csv'
          file
        else
          halt 400, { message: 'Tipo de arquivo inválido. Apenas arquivos CSV são permitidos.' }.to_json
        end
      else
        halt 400, { message: 'Nenhum arquivo foi enviado.' }.to_json
      end
    end
  end

  get '/exams' do
    content_type :json

    response = Faraday.get("#{backend_url}/tests")
    exams = JSON.parse(response.body)

    exams.to_json
  end

  get '/exams/:token' do
    content_type :json

    response = Faraday.get("#{backend_url}/tests/#{params[:token]}")
    exam = JSON.parse(response.body)

    exam.to_json
  end

  post '/import' do
    content_type :json
    file = validate_file_upload

    payload = {
      file: Faraday::Multipart::FilePart.new(file, 'text/csv', params[:file][:filename])
    }

    response = faraday_connection.post("#{backend_url}/import", payload)

    result = if response.success?
               { message: 'Importando Dados, aguarde um momento.' }
             else
               { message: 'Erro ao importar dados.' }
             end

    result.to_json
  end

  get '/' do
    content_type 'text/html'
    erb :'index.html', layout: :'layouts/application.html'
  end
end
