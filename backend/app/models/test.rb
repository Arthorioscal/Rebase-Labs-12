# frozen_string_literal: true

require_relative '../../lib/database_connection'
require_relative 'patient'
require_relative 'doctor'
require_relative 'test_type'

class Test
  attr_accessor :id, :token, :result_date, :patient_cpf, :doctor_crm

  def initialize(id:, token:, result_date:, patient_cpf:, doctor_crm:)
    @id = id
    @token = token
    @result_date = result_date
    @patient_cpf = patient_cpf
    @doctor_crm = doctor_crm
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
    conn = DatabaseConnection.db_connection
    sql = <<-SQL
      SELECT 
        tests.id AS test_id, tests.token, tests.result_date, 
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

      if row['test_type_id']
        tests[test_id][:test_results] << {
          id: row['test_type_id'],
          type: row['test_type'],
          limits: row['test_limits'],
          result: row['test_result']
        }
      end
    end

    tests.values.map do |test_data|
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

  def patient
    @patient
  end

  def doctor
    @doctor
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
end