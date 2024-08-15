import { createCard } from './card.js';
import { displayExamDetails } from './details.js';
import { allExams, currentPage, displayPage } from './pagination.js';

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
      allExams.length = 0;
      allExams.push(...data);
      displayPage(currentPage);
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
}

export async function fetch_exams_token(token) {
  try {
    const response = await fetch(`/exams/${token}`);
    if (!response.ok) {
      throw new Error('Failed to fetch exam data by token');
    }
    const exam = await response.json();
    if (!exam || !exam.name) {
      throw new Error('Invalid exam data received');
    }
    displayExamDetails(exam, token);
    return exam;
  } catch (error) {
    console.error('Fetch error:', error);
    // Optionally, you can add more user-friendly error handling here
    displayErrorMessage('Falha em buscar o exame. Verifique o token e tente novamente.');
    throw error; // Re-throw the error to be caught in the calling function
  }
}

function displayErrorMessage(message) {
  const messageContainer = document.getElementById('message-container');
  if (!messageContainer) {
    console.error('Error: message-container element not found');
    return;
  }
  messageContainer.innerHTML = `
  <div class="d-flex justify-content-center mt-3">
    <div class="card text-center w-75 mx-auto mt-3"> <!-- Adjusted width to 75% -->
      <div class="card-body p-2"> <!-- Reduced padding for a thinner appearance -->
        <h5 class="card-title">Error</h5>
        <p class="card-text">${message}</p>
        <a href="/" class="btn btn-primary">Retornar</a>
      </div>
    </div>
  </div>
`;
}

export function import_button() {
  const importButton = document.getElementById('import-button');
  const fileInput = document.getElementById('file-input');

  importButton.addEventListener('click', () => {
    const file = fileInput.files[0];
    if (!file) {
      alert('Por favor, selecione um arquivo CSV para importar.');
      return;
    }

    const formData = new FormData();
    formData.append('file', file);

    console.log('Sending file to /import endpoint');

    fetch('/import', {
      method: 'POST',
      body: formData
    })
    .then(response => {
      console.log('Received response from /import endpoint');
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log('Import response:', data);
      if (data.message) {
        alert(data.message);
      } else {
        alert('Import completed successfully');
      }
      location.reload();
    })
    .catch(error => console.error('Error in importing exams', error));
  });
}