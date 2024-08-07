-- Patient
CREATE TABLE IF NOT EXISTS patients (
    cpf VARCHAR(14) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(20) NOT NULL,
    doctor_crm CHAR(10) REFERENCES doctors(crm) ON DELETE SET NULL
);

-- Doctors
CREATE TABLE IF NOT EXISTS doctors (
    crm VARCHAR(10) PRIMARY KEY,
    crm_state CHAR(2) NOT NULL CHECK (LENGTH(crm_state) = 2),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Tests
CREATE TABLE IF NOT EXISTS tests (
    id SERIAL PRIMARY KEY,
    token VARCHAR(6) NOT NULL UNIQUE,
    result_date DATE NOT NULL,
    patient_cpf VARCHAR(14) REFERENCES patients(cpf) ON DELETE CASCADE,
    doctor_crm VARCHAR(10) REFERENCES doctors(crm) ON DELETE CASCADE
);

-- Test types
CREATE TABLE IF NOT EXISTS test_types (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    limits VARCHAR(20) NOT NULL,
    result VARCHAR(20) NOT NULL,
    test_id INT REFERENCES tests(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_patient_cpf ON patients(cpf);
CREATE INDEX idx_doctor_crm ON doctors(crm);
CREATE INDEX idx_test_token ON tests(token);
CREATE INDEX idx_tests_patient_cpf ON tests(patient_cpf);
CREATE INDEX idx_tests_doctor_crm ON tests(doctor_crm);
CREATE INDEX idx_test_types_test_id ON test_types(test_id);