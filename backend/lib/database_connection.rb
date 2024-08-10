# frozen_string_literal: true

require 'pg'

module DatabaseConnection
  def self.db_connection
    env = ENV['RACK_ENV'] || 'development'

    if env == 'test'
      PG.connect(
        host: ENV['TEST_DATABASE_HOST'] || 'postgres',
        user: ENV['TEST_DATABASE_USER'] || 'user',
        password: ENV['TEST_DATABASE_PASSWORD'] || 'pass',
        dbname: ENV['TEST_DATABASE_NAME'] || 'test_rebaselabs'
      )
    else
      PG.connect(
        host: ENV['DATABASE_HOST'],
        user: ENV['DATABASE_USER'],
        password: ENV['DATABASE_PASSWORD'],
        dbname: ENV['DATABASE_NAME']
      )
    end
  end
end