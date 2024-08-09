require 'csv'
require 'pg'

conn = PG.connect(
  dbname: 'rebaselabs',
  user: 'user',
  password: 'pass',
  host: 'postgres',
  port: '5432'
)

CSV.foreach('backend/db/persistence/data.csv', headers: true, col_sep: ';') do |row|
  conn.exec_params(
    'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) ON CONFLICT (crm) DO NOTHING',
    [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
  )

  conn.exec_params(
    'INSERT INTO patients (cpf, name, email, birth_date, address, city, state, doctor_crm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (cpf) DO NOTHING',
    [row['cpf'], row['nome paciente'], row['email paciente'], row['data nascimento paciente'], row['endereço/rua paciente'], row['cidade paciente'], row['estado patiente'], row['crm médico']]
  )

  conn.exec_params(
    'INSERT INTO tests (token, result_date, patient_cpf, doctor_crm) VALUES ($1, $2, $3, $4) ON CONFLICT (token) DO NOTHING',
    [row['token resultado exame'], row['data exame'], row['cpf'], row['crm médico']]
  )

  conn.exec_params(
    'INSERT INTO test_types (type, limits, result, test_id) VALUES ($1, $2, $3, (SELECT id FROM tests WHERE token = $4))',
    [row['tipo exame'], row['limites tipo exame'], row['resultado tipo exame'], row['token resultado exame']]
  )
end

conn.close
