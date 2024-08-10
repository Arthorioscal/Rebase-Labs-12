# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/models/patient'
require_relative '../../app/models/doctor'

RSpec.describe Patient do
  describe 'create' do
    it 'creates a new patient' do
      Doctor.create(crm: 'CRM123', crm_state: 'SP', name: 'Dr. Naomi Hunter', email: 'naomi.hunter@foxhound.com')
      patient = Patient.create(
        cpf: '12345678901',
        name: 'Solid Snake',
        email: 'solid.snake@foxhound.com',
        birth_date: '1972-01-01',
        address: 'Outer Heaven',
        city: 'Zanzibar Land',
        state: 'Zanzibar',
        doctor_crm: 'CRM123'
      )

      expect(patient).to be_a(Patient)
      expect(patient.cpf).to eq('12345678901')
      expect(patient.name).to eq('Solid Snake')
      expect(patient.email).to eq('solid.snake@foxhound.com')
      expect(patient.birth_date).to eq('1972-01-01')
      expect(patient.address).to eq('Outer Heaven')
      expect(patient.city).to eq('Zanzibar Land')
      expect(patient.state).to eq('Zanzibar')
      expect(patient.doctor_crm).to eq('CRM123')
    end

    it 'fails to create if all the requirements are not met' do
      invalid_patient_params = {
        cpf: nil,
        name: 'Solid Snake',
        email: 'solid.snake@foxhound.com',
        birth_date: '1972-01-01',
        address: 'Outer Heaven',
        city: 'Zanzibar Land',
        state: 'Zanzibar',
        doctor_crm: 'CRM123'
      }

      expect {
        Patient.create(invalid_patient_params)
      }.to raise_error(ArgumentError)
    end
  end

  describe '.all' do
    it 'retrieves all patients from the database' do
      Doctor.create(crm: 'CRM123', crm_state: 'SP', name: 'Dr. Naomi Hunter', email: 'naomi.hunter@foxhound.com')
      Doctor.create(crm: 'CRM456', crm_state: 'RJ', name: 'Dr. Hal Emmerich', email: 'hal.emmerich@foxhound.com')
      
      Patient.create(cpf: '12345678901', name: 'Solid Snake', email: 'solid.snake@foxhound.com', birth_date: '1972-01-01', address: 'Outer Heaven', city: 'Zanzibar Land', state: 'Zanzibar', doctor_crm: 'CRM123')
      Patient.create(cpf: '98765432100', name: 'Raiden', email: 'raiden@foxhound.com', birth_date: '1980-02-02', address: 'Big Shell', city: 'New York', state: 'NY', doctor_crm: 'CRM456')
      
      patients = Patient.all
  
      expect(patients.length).to eq(2)
      expect(patients.map(&:name)).to include('Solid Snake', 'Raiden')
    end
  end
end