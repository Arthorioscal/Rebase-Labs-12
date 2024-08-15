export function displayExamDetails(exam, token) {
  // Parse the exam data into constants
  const exam_patient_name = exam.name;
  const exam_patient_cpf = exam.cpf;
  const exam_patient_email = exam.email;
  const exam_patient_birthday = exam.birthday;
  const exam_result_date = exam.result_date;
  const doctor_name = exam.doctor.name;
  const doctor_crm = exam.doctor.crm;
  const doctor_crm_state = exam.doctor.crm_state;

  const examResults = exam.tests.map(result => {
    const test_type = result.test_type;
    const test_limits = result.test_limits;
    const test_result = result.result;

    return { test_type, test_limits, test_result };
  });

  // Clear search form if it exists
  const searchInput = document.querySelector("input#search-input"); // Ensure this ID matches
  if (searchInput) {
    searchInput.value = "";
  }

  // Create section
  const section = document.createElement("section");
  section.id = "test-info";
  section.className = "container my-5";

  // Create header
  const header = document.createElement("div");
  header.className = "d-flex justify-content-between align-items-center mb-5";

  const date = new Date(Date.parse(exam_result_date));

  const h1 = document.createElement("h1");
  h1.className = "text-primary";
  h1.innerText = `Exame: ${token} - ${date.toLocaleDateString("pt-BR")}`;

  const backButton = document.createElement("a");
  backButton.href = "/";
  backButton.className = "btn btn-outline-primary btn-sm";
  backButton.innerHTML = "&larr; Retornar";
  backButton.style.fontSize = "1rem";
  backButton.style.padding = "10px 20px"; 

  header.append(h1, backButton);
  section.append(header);

  const row = document.createElement("div");
  row.className = "row g-4"; // Adds spacing between the cards

  const patientCard = document.createElement("div");
  patientCard.className = "card col-md-6 shadow-sm border-0";

  const patientCardBody = document.createElement("div");
  patientCardBody.className = "card-body";

  const patientTitle = document.createElement("h5");
  patientTitle.className = "card-title text-primary";
  patientTitle.innerText = "Paciente";

  const patientDl = document.createElement("dl");
  patientDl.className = "row mb-0"; // Removes default margin-bottom

  const patientNameTerm = document.createElement("dt");
  patientNameTerm.className = "col-sm-4 text-muted";
  patientNameTerm.innerText = "Nome:";
  const patientName = document.createElement("dd");
  patientName.className = "col-sm-8 fw-bold";
  patientName.innerText = exam_patient_name;

  const patientEmailTerm = document.createElement("dt");
  patientEmailTerm.className = "col-sm-4 text-muted";
  patientEmailTerm.innerText = "E-mail:";
  const patientEmail = document.createElement("dd");
  patientEmail.className = "col-sm-8";
  patientEmail.innerText = exam_patient_email;

  const birthdateTerm = document.createElement("dt");
  birthdateTerm.className = "col-sm-4 text-muted";
  birthdateTerm.innerText = "Nascimento:";
  const patientBirthdate = document.createElement("dd");
  patientBirthdate.className = "col-sm-8";
  let birthdate = new Date(Date.parse(exam_patient_birthday));
  patientBirthdate.innerText = birthdate.toLocaleDateString("pt-BR");

  patientDl.append(patientNameTerm, patientName, patientEmailTerm, patientEmail, birthdateTerm, patientBirthdate);
  patientCardBody.append(patientTitle, patientDl);
  patientCard.append(patientCardBody);
  row.append(patientCard);

  const doctorCard = document.createElement("div");
  doctorCard.className = "card col-md-6 shadow-sm border-0";

  const doctorCardBody = document.createElement("div");
  doctorCardBody.className = "card-body";

  const doctorTitle = document.createElement("h5");
  doctorTitle.className = "card-title text-primary";
  doctorTitle.innerText = "Médico";

  const doctorDl = document.createElement("dl");
  doctorDl.className = "row mb-0";

  const doctorNameTerm = document.createElement("dt");
  doctorNameTerm.className = "col-sm-4 text-muted";
  doctorNameTerm.innerText = "Nome:";
  const doctorName = document.createElement("dd");
  doctorName.className = "col-sm-8 fw-bold";
  doctorName.innerText = doctor_name;

  const crmTerm = document.createElement("dt");
  crmTerm.className = "col-sm-4 text-muted";
  crmTerm.innerText = "CRM:";
  const doctorCrm = document.createElement("dd");
  doctorCrm.className = "col-sm-8";
  doctorCrm.innerText = `${doctor_crm}/${doctor_crm_state}`;

  doctorDl.append(doctorNameTerm, doctorName, crmTerm, doctorCrm);
  doctorCardBody.append(doctorTitle, doctorDl);
  doctorCard.append(doctorCardBody);
  row.append(doctorCard);

  section.append(row);

  const resultsElement = document.createElement("div");
  resultsElement.className = "card mt-4 shadow-sm border-0";

  const resultsCardBody = document.createElement("div");
  resultsCardBody.className = "card-body";

  const resultsTitle = document.createElement("h5");
  resultsTitle.className = "card-title text-primary";
  resultsTitle.innerText = "Resultados";

  resultsCardBody.append(resultsTitle);

  const table = document.createElement("table");
  table.className = "table table-striped table-hover mt-3"; // Adds striped rows

  const thead = document.createElement("thead");
  thead.className = "table-light"; // Light background for header
  const headRow = document.createElement("tr");

  const thType = document.createElement("th");
  thType.innerText = "Tipo";
  const thRange = document.createElement("th");
  thRange.innerText = "Intervalo";
  const thResult = document.createElement("th");
  thResult.innerText = "Resultado";

  headRow.append(thType, thRange, thResult);
  thead.append(headRow);
  table.append(thead);

  const tbody = document.createElement("tbody");

  examResults.forEach(t => {
    const tr = document.createElement("tr");

    const type = document.createElement("td");
    type.innerText = t.test_type;

    const range = document.createElement("td");
    range.innerText = t.test_limits;

    const result = document.createElement("td");
    result.innerText = t.test_result;

    tr.append(type, range, result);
    tbody.append(tr);
  });
  table.append(tbody);

  resultsCardBody.append(table);
  resultsElement.append(resultsCardBody);
  section.append(resultsElement);

  const main = document.querySelector("main");
  main.innerHTML = "";
  main.append(section);
}
