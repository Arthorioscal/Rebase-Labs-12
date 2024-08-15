import { fetch_exams, fetch_exams_token, import_button } from './api.js';

document.addEventListener('DOMContentLoaded', () => {
  const searchForm = document.getElementById('search-form');
  const searchInput = document.getElementById('search-input');
  const searchButton = document.getElementById('search-button');
  const importButton = document.getElementById('import-button');
  const errorContainer = document.getElementById('error-container'); // Container for error card

  const createCardWithMessage = (message) => {
    const card = document.createElement('div');
    card.className = 'card text-center w-90 mx-auto mt-3';

    const cardBody = document.createElement('div');
    cardBody.className = 'card-body p-1';

    const messageElement = document.createElement('p');
    messageElement.className = 'card-text';
    messageElement.textContent = message;
    cardBody.appendChild(messageElement);

    const backButton = document.createElement('button');
    backButton.className = 'btn btn-primary';
    backButton.textContent = 'Retornar';
    backButton.addEventListener('click', () => {
      window.location.href = '/';
    });
    cardBody.appendChild(backButton);

    card.appendChild(cardBody);
    return card;
  };

  const handleSearch = (event) => {
    event.preventDefault();
    console.log('Form submission prevented');
    const token = searchInput.value.trim();
    const container = document.getElementById('exams-container');
    const messageContainer = document.getElementById('message-container');
    
    if (container) container.innerHTML = '';
    if (messageContainer) messageContainer.innerHTML = '';
    if (errorContainer) errorContainer.innerHTML = ''; // Clear previous error card

    if (token) {
      fetch_exams_token(token)
        .then((exams) => {
          console.log('Exams fetched successfully');
          if (container) {
            exams.forEach(exam => {
              const examElement = document.createElement('div');
              examElement.textContent = exam.name;
              container.appendChild(examElement);
            });
          }
        })
    } else {
      const message = 'Por favor, insira um token válido';
      if (errorContainer) {
        const card = createCardWithMessage(message);
        errorContainer.appendChild(card);
      }
    }
  };

  searchForm.addEventListener('submit', handleSearch);
  searchButton.addEventListener('click', handleSearch);

  searchInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
      event.preventDefault();
      handleSearch(event);
    }
  });

  console.log('Fetching all exams on page load');
  fetch_exams();

  console.log('Initializing import button');
  import_button();
});