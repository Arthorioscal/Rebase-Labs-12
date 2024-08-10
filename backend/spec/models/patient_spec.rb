# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/models/patient'
require_relative '../../app/models/doctor'

RSpec.describe Patient do
  describe 'initialize' do
    it 'initializes with correct attributes' do
      patient = Patient.new(
        cpf: '98765432100',
        name: 'Jane Doe',
        email: 'jane@example.com',
        birth_date: '1990-02-02',
        address: '456 Elm St',
        city: 'Othertown',
        state: 'Otherstate',
        doctor_crm: 'CRM456'
      )

      expect(patient.cpf).to eq('98765432100')
      expect(patient.name).to eq('Jane Doe')
      expect(patient.email).to eq('jane@example.com')
      expect(patient.birth_date).to eq('1990-02-02')
      expect(patient.address).to eq('456 Elm St')
      expect(patient.city).to eq('Othertown')
      expect(patient.state).to eq('Otherstate')
      expect(patient.doctor_crm).to eq('CRM456')
    end
  end

  describe '.all' do
    it 'retrieves all patients from the database' do
      Doctor.create(crm: 'CRM123', crm_state: 'SP', name: 'Dr. Solid Snake', email: 'solid.snake@mgs.com')
      Doctor.create(crm: 'CRM456', crm_state: 'RJ', name: 'Dr. Big Boss', email: 'big.boss@mgs.com')
      
      Patient.create(cpf: '12345678901', name: 'John Doe', email: 'john@example.com', birth_date: '1980-01-01', address: '123 Main St', city: 'Anytown', state: 'Anystate', doctor_crm: 'CRM123')
      Patient.create(cpf: '98765432100', name: 'Jane Doe', email: 'jane@example.com', birth_date: '1990-02-02', address: '456 Elm St', city: 'Othertown', state: 'Otherstate', doctor_crm: 'CRM456')
      
      patients = Patient.all

      expect(patients.length).to eq(2)
      expect(patients.map(&:name)).to include('John Doe', 'Jane Doe')
    end
  end
end