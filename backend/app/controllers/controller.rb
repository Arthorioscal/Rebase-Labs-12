# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'json'
require_relative '../../lib/database_connection'
require_relative '../models/doctor'
require_relative '../models/patient'
require_relative '../models/test'
require_relative '../models/test_type'

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
        patient: {
          cpf: test.patient[:cpf],
          name: test.patient[:name],
          email: test.patient[:email],
          birth_date: test.patient[:birth_date]
        },
        doctor: {
          crm: test.doctor[:crm],
          crm_state: test.doctor[:crm_state],
          name: test.doctor[:name],
          email: test.doctor[:email]
        },
        test_results: test.test_results.map do |result|
          {
            type: result.type,
            limits: result.limits,
            result: result.result
          }
        end
      }
    end
  
    tests.to_json
  end

  run! if app_file == $0
end
