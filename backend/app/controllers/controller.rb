# frozen_string_literal: true

require_relative '../models/doctor'
require_relative '../models/patient'
require_relative '../models/test'
require_relative '../models/test_type'
require_relative '../../db/persistence/import'
require_relative '../../lib/database_connection'
require_relative '../../jobs/import_data_job'

class Controller < Sinatra::Base
  before do
    content_type :json
  end

  helpers do
    def render_test(test)
      {
        result_token: test.token,
        result_date: test.result_date,
        cpf: test.patient[:cpf],
        name: test.patient[:name],
        email: test.patient[:email],
        birthday: test.patient[:birth_date],
        doctor: {
          crm: test.doctor[:crm],
          crm_state: test.doctor[:crm_state],
          name: test.doctor[:name]
        },
        tests: test.test_results.map do |result|
          {
            test_type: result.type,
            test_limits: result.limits,
            result: result.result
          }
        end
      }
    end

    def handle_file_upload(file_param)
      tempfile = file_param[:tempfile]
      filename = file_param[:filename]
      saved_file_path = "./#{filename}"

      File.open(saved_file_path, 'wb') do |file|
        file.write(tempfile.read)
      end

      saved_file_path
    end
  end

  get '/api/v1/tests' do
    tests = Test.all.map { |test| render_test(test) }
    halt 404, { error: 'Records not found' }.to_json if tests.empty?
    status 200
    tests.to_json
  rescue ActiveRecord::RecordNotFound => e
    halt 404, { error: "Records not found: #{e.message}" }.to_json
  rescue StandardError => e
    halt 500, { error: "Internal server error: #{e.message}" }.to_json
  end

  get '/api/v1/tests/:token' do
    test = Test.find_by_token(params[:token])
    halt 404, { error: 'Test not found' }.to_json unless test

    status 200
    render_test(test).to_json
  end

  post '/api/v1/import' do
    halt 400, { message: 'No file uploaded' }.to_json unless params[:file] && params[:file][:tempfile]

    begin
      saved_file_path = handle_file_upload(params[:file])

      ImportDataJob.perform_async(saved_file_path)
      status 200
      { message: 'Data import started successfully' }.to_json
    rescue StandardError => e
      halt 500, { message: 'Erro ao importar dados.' }.to_json
    end
  end

  run! if app_file == $0
end
