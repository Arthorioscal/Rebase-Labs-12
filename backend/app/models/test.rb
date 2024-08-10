# frozen_string_literal: true

require_relative '../../lib/database_connection'

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
    tests = conn.exec('SELECT * FROM tests')
    tests.map do |test|
      Test.new(
        id: test['id'],
        token: test['token'],
        result_date: test['result_date'],
        patient_cpf: test['patient_cpf'],
        doctor_crm: test['doctor_crm']
      )
    end
  end
end