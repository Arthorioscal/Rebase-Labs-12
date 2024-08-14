import { fetch_exams, fetch_exams_token, import_button } from './api.js';

document.addEventListener('DOMContentLoaded', () => {
  const searchButton = document.getElementById('search-button');
  const searchInput = document.getElementById('search-input');
  const importButton = document.getElementById('import-button');

  searchButton.addEventListener('click', () => {
    const token = searchInput.value.trim();
    const container = document.getElementById('exams-container');
    container.innerHTML = ''; // Limpa o contêiner antes de exibir os resultados da busca

    if (token) {
      console.log('Fetching exam with token:', token);
      fetch_exams_token(token);
    } else {
      alert('Please enter a valid token');
    }
  });

  // Fetch all exams on page load
  console.log('Fetching all exams on page load');
  fetch_exams();

  // Initialize import button functionality
  console.log('Initializing import button');
  import_button();
});