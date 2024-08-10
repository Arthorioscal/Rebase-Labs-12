# frozen_string_literal: true

require_relative '../../lib/database_connection'

class Patient
  attr_accessor :cpf, :name, :email, :birth_date, :address, :city, :state, :doctor_crm

  def initialize(cpf:, name:, email:, birth_date:, address:, city:, state:, doctor_crm:)
    @cpf = cpf
    @name = name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
    @doctor_crm = doctor_crm
  end

  def self.create(cpf:, name:, email:, birth_date:, address:, city:, state:, doctor_crm:)
    conn = DatabaseConnection.db_connection
    sql = 'INSERT INTO patients (cpf, name, email, birth_date, address, city, state, doctor_crm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING cpf, name, email, birth_date, address, city, state, doctor_crm'
    result = conn.exec_params(sql, [cpf, name, email, birth_date, address, city, state, doctor_crm])
    patient_data = result.first
    Patient.new(
      cpf: patient_data['cpf'],
      name: patient_data['name'],
      email: patient_data['email'],
      birth_date: patient_data['birth_date'],
      address: patient_data['address'],
      city: patient_data['city'],
      state: patient_data['state'],
      doctor_crm: patient_data['doctor_crm']
    )
  end

  def self.all
    conn = DatabaseConnection.db_connection
    patients = conn.exec('SELECT * FROM patients')
    patients.map do |patient|
      Patient.new(
        cpf: patient['cpf'],
        name: patient['name'],
        email: patient['email'],
        birth_date: patient['birth_date'],
        address: patient['address'],
        city: patient['city'],
        state: patient['state'],
        doctor_crm: patient['doctor_crm']
      )
    end
  end
end