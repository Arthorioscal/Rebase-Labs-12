# frozen_string_literal: true

require_relative '../../lib/database_connection'

class Doctor
  attr_accessor :crm, :crm_state, :name, :email

  def initialize(crm:, crm_state:, name:, email:)
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end

  def self.create(crm:, crm_state:, name:, email:)
    conn = DatabaseConnection.db_connection
    sql = 'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) RETURNING crm, crm_state, name, email'
    result = conn.exec_params(sql, [crm, crm_state, name, email]).first

    Doctor.new(
      crm: result['crm'],
      crm_state: result['crm_state'],
      name: result['name'],
      email: result['email']
    )
  end

  def self.all
    conn = DatabaseConnection.db_connection
    doctors = conn.exec('SELECT * FROM doctors')
    doctors.map do |doctor|
      Doctor.new(
        crm: doctor['crm'],
        crm_state: doctor['crm_state'],
        name: doctor['name'],
        email: doctor['email']
      )
    end
  end

  def self.find(crm)
    conn = DatabaseConnection.db_connection
    sql = 'SELECT * FROM doctors WHERE crm = $1'
    doctor = conn.exec_params(sql, [crm]).first
    return unless doctor

    Doctor.new(
      crm: doctor['crm'],
      crm_state: doctor['crm_state'],
      name: doctor['name'],
      email: doctor['email']
    )
  end
end
