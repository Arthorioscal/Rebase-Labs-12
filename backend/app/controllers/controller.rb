# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'json'
require 'sidekiq'
require 'sidekiq/web'
require_relative '../models/doctor'
require_relative '../models/patient'
require_relative '../models/test'
require_relative '../models/test_type'
require_relative '../../db/persistence/import'
require_relative '../../lib/database_connection'
require_relative '../../jobs/import_data_job'

class Controller < Sinatra::Base
  get '/' do
    'Hello, world!'
  end

  get '/tests' do
    content_type :json
    tests = Test.all.map do |test|
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
    puts "Tests to be returned: #{tests}" # Debugging statement
    tests.to_json
  end

  get '/tests/:token' do
    content_type :json
    test = Test.find_by_token(params[:token])
    halt 404, { error: 'Test not found' }.to_json unless test

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
    }.to_json
  end

  post '/import' do
    logger.info 'Received request to /import endpoint'
    ImportDataJob.perform_async
    status 200
    { message: 'Data imported successfully' }.to_json
  rescue StandardError => e
    logger.error "Error in /import endpoint: #{e.message}"
    status 500
    { error: e.message }.to_json
  end

  run! if app_file == $0
end
