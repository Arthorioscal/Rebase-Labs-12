require 'pg'

module DatabaseConnection
  def self.db_connection
    PG.connect(
      host: ENV['DATABASE_HOST'],
      user: ENV['DATABASE_USER'],
      password: ENV['DATABASE_PASSWORD'],
      dbname: ENV['DATABASE_NAME']
    )
  end
end