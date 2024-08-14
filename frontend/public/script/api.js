export function fetch_exams() {
  console.log('fetch_exams called');
  fetch('/exams')
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log('Exams data:', data);
      const container = document.getElementById('exams-container');
      container.innerHTML = ''; // Limpa o contêiner antes de exibir os exames
      data.forEach(exam => {
        const examDiv = document.createElement('div');
        examDiv.className = 'exam';
        examDiv.innerHTML = `
          <h2>${exam.name}</h2>
          <p>CPF: ${exam.cpf}</p>
          <p>Email: ${exam.email}</p>
          <p>Data de Nascimento: ${exam.birthday}</p>
          <p>Data do Resultado: ${exam.result_date}</p>
          <h3>Médico</h3>
          <p>Nome: ${exam.doctor.name}</p>
          <p>CRM: ${exam.doctor.crm} - ${exam.doctor.crm_state}</p>
          <h3>Resultados dos Exames</h3>
          ${exam.tests.map(result => `
            <div class="result">
              <p>Tipo: ${result.test_type}</p>
              <p>Limites: ${result.test_limits}</p>
              <p>Resultado: ${result.result}</p>
            </div>
          `).join('')}
        `;
        container.appendChild(examDiv);
      });
    })
    .catch(error => console.error('Error in listing exams', error));
}

export function fetch_exams_token(token) {
  console.log('fetch_exams_token called with token:', token);
  fetch(`/exams/${token}`)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(exam => {
      console.log('Exam data:', exam);
      const container = document.getElementById('exams-container');
      container.innerHTML = ''; // Limpa o contêiner antes de exibir o exame
      const examDiv = document.createElement('div');
      examDiv.className = 'exam';
      examDiv.innerHTML = `
        <h2>${exam.name}</h2>
        <p>CPF: ${exam.cpf}</p>
        <p>Email: ${exam.email}</p>
        <p>Data de Nascimento: ${exam.birthday}</p>
        <p>Data do Resultado: ${exam.result_date}</p>
        <h3>Médico</h3>
        <p>Nome: ${exam.doctor.name}</p>
        <p>CRM: ${exam.doctor.crm} - ${exam.doctor.crm_state}</p>
        <h3>Resultados dos Exames</h3>
        ${exam.tests.map(result => `
          <div class="result">
            <p>Tipo: ${result.test_type}</p>
            <p>Limites: ${result.test_limits}</p>
            <p>Resultado: ${result.result}</p>
          </div>
        `).join('')}
      `;
      container.appendChild(examDiv);
    })
    .catch(error => console.error('Error to find exam by token', error));
}

export function import_button() {
  console.log('import_button called');
  const importButton = document.getElementById('import-button');
  importButton.addEventListener('click', () => {
    console.log('Import button clicked');
    fetch('/import', { method: 'POST' })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then(data => {
        console.log('Import response:', data); // Adiciona depuração aqui
        if (data.message) {
          alert(data.message); // Display the message from the server
        } else {
          alert('Import completed successfully');
        }
        location.reload();
      })
      .catch(error => console.error('Error in importing exams', error));
  });
}