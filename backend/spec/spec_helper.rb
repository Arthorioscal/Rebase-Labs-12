require 'pg'
require 'rspec'
require 'rack/test'
require 'json'
require 'byebug'
require 'rake'
require_relative '../lib/database_connection'
require_relative '../app/controllers/controller'
require_relative '../app/models/doctor'
require_relative '../app/models/patient'
require_relative '../app/models/test'
require_relative '../app/models/test_type'

ENV['RACK_ENV'] = 'test'

DB_CONNECTION = PG.connect(
  host: 'postgres',
  dbname: ENV['DATABASE_NAME'] || 'test_rebaselabs',
  user: 'user',
  password: 'pass'
)
DB_CONNECTION.exec("SET client_min_messages TO WARNING;")

load File.expand_path('../../Rakefile', __FILE__)

def truncate_tables(connection)
  tables = connection.exec("SELECT tablename FROM pg_tables WHERE schemaname = 'public';")
  tables.each do |table|
    connection.exec("TRUNCATE TABLE #{table['tablename']} RESTART IDENTITY CASCADE;")
  end
end

def init_sql(connection, file_path)
  sql = File.read(file_path)
  puts "Executing init.sql..."
  connection.exec(sql)
end

RSpec.configure do |config|
  config.before(:suite) do
    puts "Creating test database..."
    Rake::Task['db:create_test'].invoke
    puts "Initializing test database schema..."
    init_sql(DB_CONNECTION, File.expand_path('../../db/persistence/init.sql', __FILE__))
    puts "Truncating tables before suite..."
    truncate_tables(DB_CONNECTION)
  end

  config.around(:each) do |example|
    truncate_tables(DB_CONNECTION)
    example.run
  end

  config.after(:suite) do
    puts ''
    puts "Closing database connections..."
    DB_CONNECTION.exec("SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'test_rebaselabs' AND pid <> pg_backend_pid();")
    DB_CONNECTION.close
    puts "Dropping test database..."
    Rake::Task['db:drop_test'].invoke
  end
end