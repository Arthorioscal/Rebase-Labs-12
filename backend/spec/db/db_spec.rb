require 'spec_helper'

RSpec.describe 'Database setup and cleanup' do
  it 'ensures the setup is correct' do
    result = DB_CONNECTION.exec('SELECT * FROM patients;')

    expect(result.fields).to eq(%w[cpf name email birth_date address city state doctor_crm])
  end

  it 'ensures the database is clean before each test' do
    DB_CONNECTION.exec("INSERT INTO patients (cpf, name, email, birth_date, address, city, state) VALUES ('12345678900', 'Big Boss', 'bigboss@mgs.com', '1935-01-01', '123 Test St', 'Test City', 'Test State');")

    result = DB_CONNECTION.exec("SELECT * FROM patients WHERE name = 'Big Boss';")
    expect(result.ntuples).to eq(1)
  end

  it 'ensures the database is clean after the previous test' do
    result = DB_CONNECTION.exec('SELECT * FROM patients;')

    expect(result.ntuples).to eq(0)
  end
end
