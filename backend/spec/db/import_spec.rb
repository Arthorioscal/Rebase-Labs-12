# require 'spec_helper'

# RSpec.describe 'Import csv data' do
#   it 'imports data from csv' do
#     import_script_path = File.expand_path('../../db/persistence/import.rb', __dir__)
#     system("ruby #{import_script_path}")

#     result_doctors = DB_CONNECTION.exec('SELECT * FROM doctors;')
#     expect(result_doctors.ntuples).to eq(9)
#     result_patients = DB_CONNECTION.exec('SELECT * FROM patients;')
#     expect(result_patients.ntuples).to eq(50)
#     result_tests = DB_CONNECTION.exec('SELECT * FROM tests;')
#     expect(result_tests.ntuples).to eq(300)
#     result_test_types = DB_CONNECTION.exec('SELECT * FROM test_types;')
#     expect(result_test_types.ntuples).to eq(3900)
#   end
# end
