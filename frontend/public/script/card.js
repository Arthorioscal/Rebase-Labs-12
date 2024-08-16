import { fetch_exams_token } from './api.js';

export function createCard(exam, rowDiv, container) {
  const colDiv = document.createElement('div');
  colDiv.className = 'col-md-6 mb-4';

  const cardLink = document.createElement('a');
  cardLink.href = '#';
  cardLink.className = 'text-decoration-none card-link-hover';
  cardLink.addEventListener('click', (event) => {
    event.preventDefault();
    fetch_exams_token(exam.result_token);
  });

  const card = document.createElement('div');
  card.className = 'card shadow-sm rounded-card border-0';
  card.setAttribute('style', 'background-color: #f8f9fa; width: 100%; margin-bottom: 0.5rem;');

  // Create card body
  const cardBody = document.createElement('div');
  cardBody.className = 'card-body';

  // Create row for card content
  const row = document.createElement('div');
  row.className = 'row';

  // First column
  const col1 = document.createElement('div');
  col1.className = 'col-md-7';

  const cardText = document.createElement('div');
  cardText.className = 'card-text';

  // Description list
  const dl = document.createElement('dl');
  dl.className = 'list-group list-group-flush';

  // Patient
  const patientDt = document.createElement('dt');
  patientDt.className = 'small text-muted';
  patientDt.innerText = 'Paciente:';
  const patientName = document.createElement('dd');
  patientName.className = 'list-group-item border-0 p-0 text-primary';
  patientName.innerText = exam.name;

  // Doctor
  const doctorDt = document.createElement('dt');
  doctorDt.className = 'small text-muted';
  doctorDt.innerText = 'Médico:';
  const doctorName = document.createElement('dd');
  doctorName.className = 'list-group-item border-0 p-0 text-primary';
  doctorName.innerText = exam.doctor.name;

  dl.append(patientDt, patientName, doctorDt, doctorName);
  cardText.append(dl);
  col1.append(cardText);

  // Second column
  const col2 = document.createElement('div');
  col2.className = 'col-md-5 text-center border-start d-flex flex-column justify-content-around p-2';

  const token = document.createElement('h2');
  token.className = 'card-title display-6 text-primary';
  token.innerText = exam.result_token;

  const dateElement = document.createElement('p');
  dateElement.className = 'text-muted';
  let date = new Date(Date.parse(exam.result_date));
  dateElement.innerText = date.toLocaleDateString('pt-BR');

  col2.append(token, dateElement);

  // Build card
  row.append(col1, col2);
  cardBody.append(row);
  card.append(cardBody);
  cardLink.appendChild(card);
  colDiv.appendChild(cardLink);
  rowDiv.appendChild(colDiv);

  container.appendChild(rowDiv);
}
