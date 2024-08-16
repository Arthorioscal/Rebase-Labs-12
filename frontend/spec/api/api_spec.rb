require 'spec_helper'

RSpec.describe 'API', type: :request do
  describe 'GET /exams' do
    it 'returns a list of the exams from the backend' do
      expected_response_path = File.expand_path('../support/tests.json', __dir__)
      expected_response = JSON.parse(File.read(expected_response_path))
      allow(Faraday).to receive(:get).and_return(double(body: expected_response.to_json))

      get '/exams'

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response).to eq(expected_response)
    end
  end

  describe 'GET /exams/:token' do
    it 'returns a single exam from the backend' do
      expected_response_path = File.expand_path('../support/test_token.json', __dir__)
      expected_response = JSON.parse(File.read(expected_response_path))
      allow(Faraday).to receive(:get).and_return(double(body: expected_response.to_json))

      get '/exams/T9O6AI'

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response).to eq(expected_response)
    end

    it 'returns error if exam is not found' do
      allow(Faraday).to receive(:get).and_return(double(body: { error: 'Test not found' }.to_json))

      get '/exams/LINKINPARKEMUITOBOM'

      actual_response = JSON.parse(last_response.body)
      expect(actual_response['error']).to eq('Test not found')
    end
  end

  describe 'POST /import' do
    it 'imports a list of exams' do
      file_path = 'spec/support/reduced_data.csv'
      file = Rack::Test::UploadedFile.new(file_path, 'text/csv')

      post '/import', file: file

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response['message']).to eq('Importando Dados, aguarde um momento.')
    end

    it 'returns error if not file is uploaded' do
      post '/import'

      expect(last_response.status).to eq(400)
      actual_response = JSON.parse(last_response.body)
      expect(actual_response['message']).to include('Nenhum arquivo foi enviado.')
    end
    it 'returns error if file is not a CSV' do
      file_path = 'spec/support/test_token.json'
      file = Rack::Test::UploadedFile.new(file_path, 'application/json')

      post '/import', file: file

      expect(last_response.status).to eq(400)
      actual_response = JSON.parse(last_response.body)
      expect(actual_response['message']).to include('Tipo de arquivo inválido. Apenas arquivos CSV são permitidos.')
    end
  end
end
