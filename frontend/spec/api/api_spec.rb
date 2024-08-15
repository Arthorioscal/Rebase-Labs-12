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
  end

  describe 'POST /import' do
    it 'imports a list of exams' do
      post '/import'

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response['message']).to eq('Importando Dados, aguarde um momento.')
    end
  end
end
