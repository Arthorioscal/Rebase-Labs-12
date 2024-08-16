# frozen_string_literal: true

require_relative '../../lib/database_connection'
require_relative 'patient'
require_relative 'doctor'
require_relative 'test_type'
require 'redis'

class Test
  attr_reader :id, :token, :result_date, :patient_cpf, :doctor_crm, :patient, :doctor, :test_results

  def initialize(id:, token:, result_date:, patient_cpf:, doctor_crm:, patient: nil, doctor: nil, test_results: [])
    @id = id
    @token = token
    @result_date = result_date
    @patient_cpf = patient_cpf
    @doctor_crm = doctor_crm
    @patient = patient
    @doctor = doctor
    @test_results = test_results
  end

  def self.create(id:, token:, result_date:, patient_cpf:, doctor_crm:)
    conn = DatabaseConnection.db_connection
    sql = 'INSERT INTO tests (id, token, result_date, patient_cpf, doctor_crm) VALUES ($1, $2, $3, $4, $5) RETURNING id, token, result_date, patient_cpf, doctor_crm'
    result = conn.exec_params(sql, [id, token, result_date, patient_cpf, doctor_crm])
    test_data = result.first
    new(
      id: test_data['id'],
      token: test_data['token'],
      result_date: test_data['result_date'],
      patient_cpf: test_data['patient_cpf'],
      doctor_crm: test_data['doctor_crm']
    )
  end

  def self.all
    database_tests = fetch_tests_from_database_or_other_source
    tests_data = fetch_from_cache('all_tests')
    if tests_data.nil? || tests_data.count != database_tests.count
      tests_data = fetch_tests_from_database_or_other_source
    end

    tests = parse_tests_data(tests_data)
    cache_tests('all_tests', tests_data)
    tests
  end

  def self.find_by_token(token)
    cache_key = "test_#{token}"

    all_tests_data = fetch_all_tests_data_from_database
    all_tests_data.each do |test_data|
      individual_cache_key = "test_#{test_data[:token]}"
      cache_tests(individual_cache_key, test_data)
    end
    test_data = fetch_from_cache(cache_key)

    return unless test_data

    parse_tests_data([test_data]).first
  end

  def test_results
    @test_results.map do |result|
      TestType.new(
        id: result[:id],
        type: result[:type],
        limits: result[:limits],
        result: result[:result],
        test_id: id
      )
    end
  end

  def self.fetch_tests_from_database_or_other_source
    conn = DatabaseConnection.db_connection
    sql = <<-SQL
      SELECT tests.id AS test_id, tests.token, tests.result_date,
             patients.cpf AS patient_cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date AS patient_birth_date,
             doctors.crm AS doctor_crm, doctors.crm_state AS doctor_crm_state, doctors.name AS doctor_name, doctors.email AS doctor_email,
             test_types.id AS test_type_id, test_types.type AS test_type, test_types.limits AS test_limits, test_types.result AS test_result
      FROM tests
      JOIN patients ON tests.patient_cpf = patients.cpf
      JOIN doctors ON tests.doctor_crm = doctors.crm
      LEFT JOIN test_types ON tests.id = test_types.test_id
    SQL

    result = conn.exec(sql)
    group_tests(result)
  end

  def self.fetch_all_tests_data_from_database
    conn = DatabaseConnection.db_connection

    # Fetch all test records
    tests_sql = 'SELECT * FROM tests'
    tests_result = conn.exec(tests_sql).to_a

    # Fetch all patient records
    patients_sql = 'SELECT * FROM patients'
    patients_result = conn.exec(patients_sql).to_a

    # Fetch all doctor records
    doctors_sql = 'SELECT * FROM doctors'
    doctors_result = conn.exec(doctors_sql).to_a

    # Fetch all test types
    test_types_sql = 'SELECT * FROM test_types'
    test_types_result = conn.exec(test_types_sql).to_a

    # Convert results to hash for easy lookup
    patients_hash = patients_result.each_with_object({}) { |patient, hash| hash[patient['cpf']] = patient }
    doctors_hash = doctors_result.each_with_object({}) { |doctor, hash| hash[doctor['crm']] = doctor }
    test_types_hash = test_types_result.group_by { |test_type| test_type['test_id'] }

    # Combine the data
    combined_data = tests_result.map do |test|
      {
        id: test['id'],
        token: test['token'],
        result_date: test['result_date'],
        patient: patients_hash[test['patient_cpf']],
        doctor: doctors_hash[test['doctor_crm']],
        test_results: test_types_hash[test['id']] || []
      }
    end


    combined_data
  end

  def self.group_tests(result)
    tests = {}

    result.each do |row|
      test_id = row['test_id']
      tests[test_id] ||= {
        id: test_id,
        token: row['token'],
        result_date: row['result_date'],
        patient: {
          cpf: row['patient_cpf'],
          name: row['patient_name'],
          email: row['patient_email'],
          birth_date: row['patient_birth_date']
        },
        doctor: {
          crm: row['doctor_crm'],
          crm_state: row['doctor_crm_state'],
          name: row['doctor_name'],
          email: row['doctor_email']
        },
        test_results: []
      }

      next unless row['test_type_id']

      tests[test_id][:test_results] << {
        id: row['test_type_id'],
        type: row['test_type'],
        limits: row['test_limits'],
        result: row['test_result']
      }
    end

    tests.values
  end

  def self.fetch_from_cache(cache_key)
    cached_data = nil
    $redis.with { |conn| cached_data = conn.get(cache_key) }
    return unless cached_data && cached_data != '[]'

    JSON.parse(cached_data, symbolize_names: true)
  end

  def self.cache_tests(cache_key, data)
    $redis.with { |conn| conn.set(cache_key, data.to_json) }
  end

  def self.parse_tests_data(tests_data)
    tests_data.map do |test_data|
      new(
        id: test_data[:id],
        token: test_data[:token],
        result_date: test_data[:result_date],
        patient_cpf: test_data[:patient][:cpf],
        doctor_crm: test_data[:doctor][:crm],
        patient: test_data[:patient],
        doctor: test_data[:doctor],
        test_results: test_data[:test_results]
      )
    end
  end
end
