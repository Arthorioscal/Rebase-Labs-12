require 'csv'
require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  user: 'user',
  password: 'pass',
  host: 'postgres',
  port: '5432'
)

