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
    tests = Test.all
    tests.map do |test|
      {
        id: test.id,
        token: test.token,
        result_date: test.result_date,
        patient_cpf: test.patient_cpf,
        doctor_crm: test.doctor_crm
      }
    end.to_json
  end

  get '/test_types' do
    test_types = TestType.all
    test_types.map do |test_type|
      {
        id: test_type.id,
        type: test_type.type,
        limits: test_type.limits,
        result: test_type.result,
        test_id: test_type.test_id
      }
    end.to_json
  end

  get '/doctors' do
    doctors = Doctor.all
    doctors.map do |doctor|
      {
        crm: doctor.crm,
        crm_state: doctor.crm_state,
        name: doctor.name,
        email: doctor.email
      }
    end.to_json
  end

  get '/patients' do
    patients = Patient.all
    patients.map do |patient|
      {
        cpf: patient.cpf,
        name: patient.name,
        email: patient.email,
        birth_date: patient.birth_date,
        address: patient.address,
        city: patient.city,
        state: patient.state,
        doctor_crm: patient.doctor_crm
      }
    end.to_json
  end

  run! if app_file == $0
end