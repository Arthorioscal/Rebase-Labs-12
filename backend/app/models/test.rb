# frozen_string_literal: true

require_relative '../../lib/database_connection'
require_relative 'patient'
require_relative 'doctor'
require_relative 'test_type'
require 'redis'

class Test
  attr_reader :id, :token, :result_date, :patient_cpf, :doctor_crm, :patient, :doctor, :test_results

  def initialize(id:, token:, result_date:, patient_cpf:, doctor_crm:)
    @id = id
    @token = token
    @result_date = result_date
    @patient_cpf = patient_cpf
    @doctor_crm = doctor_crm
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

  def self.create(id:, token:, result_date:, patient_cpf:, doctor_crm:)
    conn = DatabaseConnection.db_connection
    sql = 'INSERT INTO tests (id, token, result_date, patient_cpf, doctor_crm) VALUES ($1, $2, $3, $4, $5) RETURNING id, token, result_date, patient_cpf, doctor_crm'
    result = conn.exec_params(sql, [id, token, result_date, patient_cpf, doctor_crm])
    test_data = result.first
    Test.new(
      id: test_data['id'],
      token: test_data['token'],
      result_date: test_data['result_date'],
      patient_cpf: test_data['patient_cpf'],
      doctor_crm: test_data['doctor_crm']
    )
  end

  def self.all
    cache_key = 'all_tests'

    cached_tests = nil
    $redis.with { |conn| cached_tests = conn.get(cache_key) }

    if cached_tests
      puts "Cached tests found: #{cached_tests}" # Debugging statement
      tests_data = JSON.parse(cached_tests, symbolize_names: true)
      puts "Parsed tests data: #{tests_data}" # Debugging statement

      tests = tests_data.map do |test_data|
        next unless test_data.is_a?(Hash) # Ensure test_data is a hash

        Test.new(
          id: test_data[:id],
          token: test_data[:token],
          result_date: test_data[:result_date],
          patient_cpf: test_data[:patient][:cpf],
          doctor_crm: test_data[:doctor][:crm]
        ).tap do |test|
          test.instance_variable_set(:@patient, test_data[:patient])
          test.instance_variable_set(:@doctor, test_data[:doctor])
          test.instance_variable_set(:@test_results, test_data[:test_results])
        end
      end.compact
    else
      # Fetch tests from the database directly
      tests = fetch_tests_from_database_or_other_source
      puts "Fetched tests from database: #{tests}" # Debugging statement
      tests_data = tests.map do |test|
        {
          id: test[:id],
          token: test[:token],
          result_date: test[:result_date],
          patient: test[:patient],
          doctor: test[:doctor],
          test_results: test[:test_results]
        }
      end
      $redis.with { |conn| conn.set(cache_key, tests_data.to_json) }
      puts "Cached tests data: #{tests_data.to_json}" # Debugging statement
    end

    tests
  end

  def test_results
    @test_results.map do |result|
      TestType.new(
        id: result[:id],
        type: result[:type], # Accessing the type value from the Hash
        limits: result[:limits],
        result: result[:result],
        test_id: id
      )
    end
  end

  def self.find_by_token(token)
    cache_key = "test_#{token}"

    cached_test = nil
    $redis.with { |conn| cached_test = conn.get(cache_key) }
    if cached_test
      test_data = JSON.parse(cached_test, symbolize_names: true)
      return Test.new(
        id: test_data[:id],
        token: test_data[:token],
        result_date: test_data[:result_date],
        patient_cpf: test_data[:patient][:cpf],
        doctor_crm: test_data[:doctor][:crm]
      ).tap do |test|
        test.instance_variable_set(:@patient, test_data[:patient])
        test.instance_variable_set(:@doctor, test_data[:doctor])
        test.instance_variable_set(:@test_results, test_data[:test_results])
      end
    end

    conn = DatabaseConnection.db_connection

    test_sql = 'SELECT * FROM tests WHERE token = $1'
    test_result = conn.exec_params(test_sql, [token]).first
    return nil unless test_result

    patient_sql = 'SELECT * FROM patients WHERE cpf = $1'
    patient_result = conn.exec_params(patient_sql, [test_result['patient_cpf']]).first

    doctor_sql = 'SELECT * FROM doctors WHERE crm = $1'
    doctor_result = conn.exec_params(doctor_sql, [test_result['doctor_crm']]).first

    test_types_sql = 'SELECT * FROM test_types WHERE test_id = $1'
    test_types_result = conn.exec_params(test_types_sql, [test_result['id']])

    test_data = {
      id: test_result['id'],
      token: test_result['token'],
      result_date: test_result['result_date'],
      patient: {
        cpf: patient_result['cpf'],
        name: patient_result['name'],
        email: patient_result['email'],
        birth_date: patient_result['birth_date']
      },
      doctor: {
        crm: doctor_result['crm'],
        crm_state: doctor_result['crm_state'],
        name: doctor_result['name']
      },
      test_results: test_types_result.map do |test_type|
        {
          id: test_type['id'],
          type: test_type['type'],
          limits: test_type['limits'],
          result: test_type['result']
        }
      end
    }

    $redis.with { |conn| conn.set(cache_key, test_data.to_json) }
    Test.new(
      id: test_data[:id],
      token: test_data[:token],
      result_date: test_data[:result_date],
      patient_cpf: test_data[:patient][:cpf],
      doctor_crm: test_data[:doctor][:crm]
    ).tap do |test|
      test.instance_variable_set(:@patient, test_data[:patient])
      test.instance_variable_set(:@doctor, test_data[:doctor])
      test.instance_variable_set(:@test_results, test_data[:test_results])
    end
  end
end
