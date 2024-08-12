require 'sidekiq'
require_relative '../db/persistence/import'
require_relative '../lib/database_connection'

class ImportDataJob
  include Sidekiq::Job

  def perform
    import_data
  rescue PG::Error => e
    Sidekiq.logger.error "Database connection failed: #{e.message}"
    raise
  end
end
