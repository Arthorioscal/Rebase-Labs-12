require 'spec_helper'
require_relative '../../app/controllers/controller'
Sidekiq::Testing.fake!

RSpec.describe Controller, type: :request do
  def app
    Controller.new
  end

  describe '/tests' do
    it 'successfully returns a list of all the tests' do
      expected_response_path = File.expand_path('../support/tests.json', __dir__)
      expected_response = JSON.parse(File.read(expected_response_path))

      doctor = Doctor.create(crm: 'B000B7CDX4', crm_state: 'SP', name: 'Sra. Calebe Louzada', email: 'calebe@email.com')
      patient = Patient.create(cpf: '066.126.400-90', name: 'Matheus Barroso', email: 'maricela@streich.com', address: 'Rua 1',
                               city: 'São Paulo', state: 'SP', birth_date: '1972-03-09', doctor_crm: 'B000B7CDX4')
      test = Test.create(id: 1, token: 'T9O6AI', result_date: '2021-11-21', patient_cpf: '066.126.400-90',
                         doctor_crm: 'B000B7CDX4')

      test_types = [
        { name: 'hemácias', test_limits: '45-52', test_result: '48' },
        { name: 'leucócitos', test_limits: '9-61', test_result: '75' },
        { name: 'plaquetas', test_limits: '11-93', test_result: '67' },
        { name: 'hdl', test_limits: '19-75', test_result: '3' },
        { name: 'ldl', test_limits: '45-54', test_result: '27' },
        { name: 'vldl', test_limits: '48-72', test_result: '27' },
        { name: 'glicemia', test_limits: '25-83', test_result: '78' },
        { name: 'tgo', test_limits: '50-84', test_result: '15' },
        { name: 'tgp', test_limits: '38-63', test_result: '34' },
        { name: 'eletrólitos', test_limits: '2-68', test_result: '92' },
        { name: 'tsh', test_limits: '25-80', test_result: '21' },
        { name: 't4-livre', test_limits: '34-60', test_result: '95' },
        { name: 'ácido úrico', test_limits: '15-61', test_result: '10' }
      ]

      test_types.each_with_index do |test_type, index|
        TestType.create(id: index + 1, type: test_type[:name], limits: test_type[:test_limits],
                        result: test_type[:test_result], test_id: 1)
      end

      get '/tests'

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response).to eq(expected_response)
    end
  end

  describe '/tests/:token' do
    it 'successfully returns a test by a token search' do
      expected_response_path = File.expand_path('../support/test_token.json', __dir__)
      expected_response = JSON.parse(File.read(expected_response_path))

      doctor = Doctor.create(crm: 'B000B7CDX4', crm_state: 'SP', name: 'Sra. Calebe Louzada', email: 'calebe@email.com')
      patient = Patient.create(cpf: '066.126.400-90', name: 'Matheus Barroso', email: 'maricela@streich.com', address: 'Rua 1',
                               city: 'São Paulo', state: 'SP', birth_date: '1972-03-09', doctor_crm: 'B000B7CDX4')
      test = Test.create(id: 1, token: 'T9O6AI', result_date: '2021-11-21', patient_cpf: '066.126.400-90',
                         doctor_crm: 'B000B7CDX4')

      test_types = [
        { name: 'hemácias', test_limits: '45-52', test_result: '48' },
        { name: 'leucócitos', test_limits: '9-61', test_result: '75' },
        { name: 'plaquetas', test_limits: '11-93', test_result: '67' },
        { name: 'hdl', test_limits: '19-75', test_result: '3' },
        { name: 'ldl', test_limits: '45-54', test_result: '27' },
        { name: 'vldl', test_limits: '48-72', test_result: '27' },
        { name: 'glicemia', test_limits: '25-83', test_result: '78' },
        { name: 'tgo', test_limits: '50-84', test_result: '15' },
        { name: 'tgp', test_limits: '38-63', test_result: '34' },
        { name: 'eletrólitos', test_limits: '2-68', test_result: '92' },
        { name: 'tsh', test_limits: '25-80', test_result: '21' },
        { name: 't4-livre', test_limits: '34-60', test_result: '95' },
        { name: 'ácido úrico', test_limits: '15-61', test_result: '10' }
      ]

      test_types.each_with_index do |test_type, index|
        TestType.create(id: index + 1, type: test_type[:name], limits: test_type[:test_limits],
                        result: test_type[:test_result], test_id: 1)
      end

      get "/tests/#{test.token}"

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response).to eq(expected_response)
    end
  end

  describe '/import' do
    it 'successfully imports a CSV file' do
      file_path = File.join(File.dirname(__FILE__), '..', 'support', 'reduced_data.csv')
      uploaded_file = Rack::Test::UploadedFile.new(file_path, 'text/csv')

      post '/import', file: uploaded_file

      expect(last_response).to be_ok
      actual_response = JSON.parse(last_response.body)
      expect(actual_response['message']).to eq('Data import started successfully')
      expect(Sidekiq::Worker.jobs.size).to eq(1)
    end
  end
end
