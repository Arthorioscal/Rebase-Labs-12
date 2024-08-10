require 'spec_helper'
require_relative '../../app/models/doctor'

RSpec.describe Doctor do
  describe 'initialize' do
    it 'initializes with correct attributes' do
      doctor = Doctor.new(crm: '12345', crm_state: 'SP', name: 'Dr. Solid Snake', email: 'solid.snake@mgs.com')

      expect(doctor.crm).to eq('12345')
      expect(doctor.crm_state).to eq('SP')
      expect(doctor.name).to eq('Dr. Solid Snake')
      expect(doctor.email).to eq('solid.snake@mgs.com')
    end
  end

  describe '.all' do
    it 'retrieves all doctors from the database' do
      Doctor.create(crm: '12345', crm_state: 'SP', name: 'Dr. Solid Snake', email: 'solid.snake@mgs.com')
      Doctor.create(crm: '67890', crm_state: 'RJ', name: 'Dr. Big Boss', email: 'big.boss@mgs.com')

      doctors = Doctor.all

      expect(doctors.length).to eq(2)
      expect(doctors.map(&:name)).to include('Dr. Solid Snake', 'Dr. Big Boss')
    end
  end

  describe '.find' do
    it 'finds a doctor by CRM' do
      Doctor.create(crm: '12345', crm_state: 'SP', name: 'Dr. Solid Snake', email: 'solid.snake@mgs.com')

      doctor = Doctor.find('12345')

      expect(doctor).not_to be_nil
      expect(doctor.name).to eq('Dr. Solid Snake')
    end

    it 'returns nil if doctor is not found' do

      doctor = Doctor.find('99999')

      expect(doctor).to be_nil
    end
  end
end
