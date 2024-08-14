document.addEventListener('DOMContentLoaded', () => {
  fetch('/exams')
    .then(response => response.json())
    .then(data => {
      const container = document.getElementById('exams-container');
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
    .catch(error => console.error('Erro ao buscar exames:', error));
});