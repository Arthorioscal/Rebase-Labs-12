require 'rack/test'
require 'rspec'
require 'json'
require 'faraday'
require 'capybara'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'logger'
require 'pg'
require_relative '../App'

ENV['RACK_ENV'] = 'test'

def app
  App
end

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new # Changed from Chromium to Chrome
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--headless')
  options.add_argument('--remote-debugging-port=9222') # Optional for remote debugging

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.app = app
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_chrome
Capybara.default_driver = :rack_test
Capybara.default_max_wait_time = 10

DB_CONNECTION = PG.connect(
  host: 'postgres',
  dbname: ENV['DATABASE_NAME'] || 'test_rebaselabs',
  user: 'user',
  password: 'pass'
)

DB_CONNECTION.exec('SET client_min_messages TO WARNING;')

load File.expand_path('../Rakefile', __dir__)

def truncate_tables(connection)
  tables = connection.exec("SELECT tablename FROM pg_tables WHERE schemaname = 'public';")
  tables.each do |table|
    connection.exec("TRUNCATE TABLE #{table['tablename']} RESTART IDENTITY CASCADE;")
  end
end

logger = Logger.new(STDOUT)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL

  config.before(:suite) do
    logger.info 'Creating test database...'
    Rake::Task['db:create_test'].invoke
    logger.info 'Initializing test database schema...'
    logger.info 'Truncating tables before suite...'
    truncate_tables(DB_CONNECTION)
  rescue StandardError => e
    logger.error "An error occurred: #{e.message}"
    raise
  end

  config.around(:each) do |example|
    truncate_tables(DB_CONNECTION)
    example.run
  rescue StandardError => e
    logger.error "An error occurred during test execution: #{e.message}"
    raise
  ensure
    truncate_tables(DB_CONNECTION)
  end

  config.after(:suite) do
    logger.info 'Closing database connections...'
    DB_CONNECTION.close
  end
end
