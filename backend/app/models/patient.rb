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