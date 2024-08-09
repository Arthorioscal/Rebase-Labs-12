# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'json'
require_relative '../../lib/database_connection'
require_relative '../models/doctor'


class Controller < Sinatra::Application
  get '/' do
    'Hello, world!'
  end

  get '/tests' do
    conn = DatabaseConnection.db_connection
    tests = conn.exec('SELECT * FROM tests')
    tests.map { |test| test }.to_json
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

  run! if app_file == $0
end