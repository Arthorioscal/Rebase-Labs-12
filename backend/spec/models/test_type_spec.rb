# frozen_string_literal: true

require_relative '../../app/models/doctor'
require_relative '../../app/models/patient'
require_relative '../../app/models/test'
require_relative '../../app/models/test_type'

RSpec.describe TestType do
  describe '.create' do
    it 'creates a new test type' do
      Doctor.create(crm: 'CRM123', name: 'Dr. Naomi Hunter', crm_state: 'NY', email: 'naomi.hunter@foxhound.com')
      Patient.create(
        cpf: '12345678901',
        name: 'Solid Snake',
        email: 'solid.snake@foxhound.com',
        birth_date: '1972-01-01',
        address: 'Outer Heaven',
        city: 'Zanzibar Land',
        state: 'Zanzibar',
        doctor_crm: 'CRM123'
      )
      Test.create(id: 1, token: 'abc123', result_date: '2023-01-01', patient_cpf: '12345678901', doctor_crm: 'CRM123')

      test_type = TestType.create(id: 1, type: 'Blood', limits: '4.0-6.0', result: '5.0', test_id: 1)
      expect(test_type).to be_a(TestType)
      expect(test_type.id.to_i).to eq(1)
      expect(test_type.type).to eq('Blood')
      expect(test_type.limits).to eq('4.0-6.0')
      expect(test_type.result).to eq('5.0')
    end
  end

  describe '.all' do
    it 'retrieves all test types from the database' do
      Doctor.create(crm: 'CRM123', name: 'Dr. Naomi Hunter', crm_state: 'NY', email: 'naomi.hunter@foxhound.com')
      Doctor.create(crm: 'CRM456', name: 'Dr. Hal Emmerich', crm_state: 'CA', email: 'hal.emmerich@foxhound.com')
      Patient.create(
        cpf: '12345678901',
        name: 'Solid Snake',
        email: 'solid.snake@foxhound.com',
        birth_date: '1972-01-01',
        address: 'Outer Heaven',
        city: 'Zanzibar Land',
        state: 'Zanzibar',
        doctor_crm: 'CRM123'
      )
      Patient.create(
        cpf: '98765432100',
        name: 'Raiden',
        email: 'raiden@foxhound.com',
        birth_date: '1980-02-02',
        address: 'Big Shell',
        city: 'New York',
        state: 'NY',
        doctor_crm: 'CRM456'
      )
      Test.create(id: 1, token: 'abc123', result_date: '2023-01-01', patient_cpf: '12345678901', doctor_crm: 'CRM123')
      Test.create(id: 2, token: 'def456', result_date: '2023-02-02', patient_cpf: '98765432100', doctor_crm: 'CRM456')
      Test.create(id: 3, token: 'ghi789', result_date: '2023-03-03', patient_cpf: '12345678901', doctor_crm: 'CRM123')

      TestType.create(id: 1, type: 'Blood', limits: '4.0-6.0', result: '5.0', test_id: 1)
      TestType.create(id: 2, type: 'Urine', limits: '1.0-2.0', result: '1.5', test_id: 2)
      TestType.create(id: 3, type: 'X-Ray', limits: 'N/A', result: 'Clear', test_id: 3)

      test_types = TestType.all
      expect(test_types.length).to eq(3)

      expect(test_types[0].type).to eq('Blood')
      expect(test_types[0].limits).to eq('4.0-6.0')
      expect(test_types[0].result).to eq('5.0')
      expect(test_types[0].test_id.to_i).to eq(1)

      expect(test_types[1].type).to eq('Urine')
      expect(test_types[1].limits).to eq('1.0-2.0')
      expect(test_types[1].result).to eq('1.5')
      expect(test_types[1].test_id.to_i).to eq(2)

      expect(test_types[2].type).to eq('X-Ray')
      expect(test_types[2].limits).to eq('N/A')
      expect(test_types[2].result).to eq('Clear')
      expect(test_types[2].test_id.to_i).to eq(3)
    end
  end
end