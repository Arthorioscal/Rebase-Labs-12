require 'csv'
require 'pg'
require_relative '../../lib/database_connection'

def import_data(file)
  conn = DatabaseConnection.db_connection

  begin
    puts "Connecting to database: #{conn.db}"
    puts "Processing file: #{file.path}"

    unless File.exist?(file.path)
      puts "File not found: #{file.path}"
      return
    end

    CSV.foreach(file.path, headers: true, col_sep: ';') do |row|
      conn.exec_params(
        'INSERT INTO doctors (crm, crm_state, name, email) VALUES ($1, $2, $3, $4) ON CONFLICT (crm) DO NOTHING',
        [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
      )

      conn.exec_params(
        'INSERT INTO patients (cpf, name, email, birth_date, address, city, state, doctor_crm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (cpf) DO NOTHING',
        [row['cpf'], row['nome paciente'], row['email paciente'], row['data nascimento paciente'],
         row['endereço/rua paciente'], row['cidade paciente'], row['estado patiente'], row['crm médico']]
      )

      conn.exec_params(
        'INSERT INTO tests (token, result_date, patient_cpf, doctor_crm) VALUES ($1, $2, $3, $4) ON CONFLICT (token) DO NOTHING',
        [row['token resultado exame'], row['data exame'], row['cpf'], row['crm médico']]
      )

      conn.exec_params(
        'INSERT INTO test_types (type, limits, result, test_id) VALUES ($1, $2, $3, (SELECT id FROM tests WHERE token = $4)) ON CONFLICT (type, test_id) DO NOTHING',
        [row['tipo exame'], row['limites tipo exame'], row['resultado tipo exame'], row['token resultado exame']]
      )
    rescue StandardError => e
      puts "Error processing row: #{row.to_h}"
      puts e.message
    end
  rescue StandardError => e
    puts "Error during import: #{e.message}"
  ensure
    conn.close
    puts 'Database connection closed'
    File.delete(file.path) if File.exist?(file.path)
    puts "File deleted: #{file.path}"
  end
end
