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