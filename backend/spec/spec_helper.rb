require 'pg'
require 'rspec'
require 'rack/test'
require 'json'
require 'byebug'
require_relative '../lib/database_connection'
require_relative '../app/controllers/controller'
require_relative '../models/doctor'
require_relative '../models/patient'
require_relative '../models/test'
require_relative '../models/test_type'

ENV['RACK_ENV'] = 'test'

