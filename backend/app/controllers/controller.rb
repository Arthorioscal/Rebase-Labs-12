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
    begin
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
      status 200
      tests.to_json
    rescue ActiveRecord::RecordNotFound => e
      status 404
      { error: "Records not found: #{e.message}" }.to_json
    rescue StandardError => e
      status 500
      { error: "Internal server error: #{e.message}" }.to_json
    end
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
    puts 'Received request to /import endpoint'

    if params[:file]
      puts "File param received: #{params[:file].inspect}"
    else
      puts 'No file param received'
    end

    if params[:file] && params[:file][:tempfile]
      tempfile = params[:file][:tempfile]
      filename = params[:file][:filename]
      saved_file_path = "./#{filename}"

      # Save the tempfile to a persistent location
      File.open(saved_file_path, 'wb') do |file|
        file.write(tempfile.read)
      end

      puts "File saved to: #{saved_file_path}"
      begin
        ImportDataJob.perform_async(saved_file_path)
        status 200
        { message: 'Data import started successfully' }.to_json
      rescue StandardError => e
        puts "Error starting import job: #{e.message}"
        status 500
        { message: 'Erro ao importar dados.' }.to_json
      end
    else
      puts 'No file uploaded'
      status 400
      { message: 'No file uploaded' }.to_json
    end
  rescue StandardError => e
    puts "Error in /import endpoint: #{e.message}"
    status 500
    { message: 'Erro ao importar dados.' }.to_json
  end

  run! if app_file == $0
end
