import { fetch_exams, fetch_exams_token, import_button } from './api.js';

document.addEventListener('DOMContentLoaded', () => {
  const searchForm = document.getElementById('search-form');
  const searchInput = document.getElementById('search-input');
  const searchButton = document.getElementById('search-button');
  const importButton = document.getElementById('import-button');

  const handleSearch = (event) => {
    event.preventDefault(); // Prevent the form from submitting and reloading the page
    console.log('Form submission prevented');
    const token = searchInput.value.trim();
    const container = document.getElementById('exams-container');
    container.innerHTML = ''; // Clear the container before displaying the search results

    if (token) {
      console.log('Fetching exam with token:', token);
      fetch_exams_token(token);
    } else {
      alert('Please enter a valid token');
    }
  };

  searchForm.addEventListener('submit', handleSearch);
  searchButton.addEventListener('click', handleSearch);

  searchInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
      console.log('Enter key pressed');
      event.preventDefault(); // Prevent the default action of the Enter key
      handleSearch(event);
    }
  });

  // Fetch all exams on page load
  console.log('Fetching all exams on page load');
  fetch_exams();

  // Initialize import button functionality
  console.log('Initializing import button');
  import_button();
});