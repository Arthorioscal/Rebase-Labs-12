require 'sidekiq'
require_relative '../db/persistence/import'
require_relative '../lib/database_connection'

class ImportDataJob
  include Sidekiq::Job

  def perform(file_path)
    logger.info "Starting import for file: #{file_path}"
    file = File.open(file_path)
    import_data(file)
    file.close
  rescue StandardError => e
    logger.error "Error in ImportDataJob: #{e.message}"
    raise e
  end
end