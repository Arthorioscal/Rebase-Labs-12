# frozen_string_literal: true

require_relative '../../lib/database_connection'

class TestType
  attr_accessor :id, :type, :limits, :result, :test_id

  def initialize(id:, type:, limits:, result:, test_id:)
    @id = id
    @type = type
    @limits = limits
    @result = result
    @test_id = test_id
  end

  def self.create(id:, type:, limits:, result:, test_id:)
    conn = DatabaseConnection.db_connection
    sql = 'INSERT INTO test_types (id, type, limits, result, test_id) VALUES ($1, $2, $3, $4, $5) RETURNING id, type, limits, result, test_id'
    result = conn.exec_params(sql, [id, type, limits, result, test_id])
    test_type_data = result.first
    TestType.new(
      id: test_type_data['id'],
      type: test_type_data['type'],
      limits: test_type_data['limits'],
      result: test_type_data['result'],
      test_id: test_type_data['test_id']
    )
  end

  def self.all
    conn = DatabaseConnection.db_connection
    test_types = conn.exec('SELECT * FROM test_types')
    test_types.map do |test_type|
      TestType.new(
        id: test_type['id'],
        type: test_type['type'],
        limits: test_type['limits'],
        result: test_type['result'],
        test_id: test_type['test_id']
      )
    end
  end
end