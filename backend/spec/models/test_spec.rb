# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/models/test'
require_relative '../../app/models/patient'
require_relative '../../app/models/doctor'

RSpec.describe Test do
  describe 'initialize' do
    it 'initializes with correct attributes' do
      test = Test.new(
        id: 1,
        token: 'abc123',
        result_date: '2023-01-01',
        patient_cpf: '12345678901',
        doctor_crm: 'CRM123'
      )

      expect(test.id).to eq(1)
      expect(test.token).to eq('abc123')
      expect(test.result_date).to eq('2023-01-01')
      expect(test.patient_cpf).to eq('12345678901')
      expect(test.doctor_crm).to eq('CRM123')
    end
  end

  describe '.all' do
    it 'retrieves all tests from the database' do
      Doctor.create(crm: 'CRM123', crm_state: 'SP', name: 'Dr. Solid Snake', email: 'solid.snake@mgs.com')
      Doctor.create(crm: 'CRM456', crm_state: 'RJ', name: 'Dr. Big Boss', email: 'big.boss@mgs.com')
      Patient.create(cpf: '12345678901', name: 'John Doe', email: 'john@example.com', birth_date: '1980-01-01', address: '123 Main St', city: 'Anytown', state: 'Anystate', doctor_crm: 'CRM123')
      Patient.create(cpf: '98765432100', name: 'Jane Doe', email: 'jane@example.com', birth_date: '1990-02-02', address: '456 Elm St', city: 'Othertown', state: 'Otherstate', doctor_crm: 'CRM456')
      Test.create(id: 1, token: 'abc123', result_date: '2023-01-01', patient_cpf: '12345678901', doctor_crm: 'CRM123')
      Test.create(id: 2, token: 'def456', result_date: '2023-02-02', patient_cpf: '98765432100', doctor_crm: 'CRM456')
  
      tests = Test.all
  
      expect(tests.length).to eq(2)
      expect(tests.map(&:token)).to include('abc123', 'def456')
    end
  end
end