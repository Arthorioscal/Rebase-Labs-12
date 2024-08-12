require 'spec_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe ImportDataJob, type: :job do
  describe '#perform' do
    it 'enqueues the job' do
      expect do
        ImportDataJob.perform_async
      end.to change(ImportDataJob.jobs, :size).by(1)
    end

    it 'calls the import_data method' do
      import_data_spy = spy('import_data')
      allow_any_instance_of(ImportDataJob).to receive(:import_data).and_call_original
      allow_any_instance_of(ImportDataJob).to receive(:import_data).and_wrap_original do |method, *args|
        import_data_spy.call(*args)
        method.call(*args)
      end

      ImportDataJob.clear
      ImportDataJob.perform_async
      ImportDataJob.drain

      expect(import_data_spy).to have_received(:call).at_least(:once)
      result_doctors = DB_CONNECTION.exec('SELECT * FROM doctors;')
      expect(result_doctors.ntuples).to eq(9)
      result_patients = DB_CONNECTION.exec('SELECT * FROM patients;')
      expect(result_patients.ntuples).to eq(50)
      result_tests = DB_CONNECTION.exec('SELECT * FROM tests;')
      expect(result_tests.ntuples).to eq(300)
      result_test_types = DB_CONNECTION.exec('SELECT * FROM test_types;')
      expect(result_test_types.ntuples).to eq(3900)
    end
  end
end
