import { createCard } from './card.js';
import { displayExamDetails } from './details.js';

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

      // Clear the container before appending new data
      const container = document.getElementById('exams-container');
      container.innerHTML = ''; // Clear previous content

      const rowDiv = document.createElement('div');
      rowDiv.className = 'row';

      data.forEach(exam => {
        createCard(exam, rowDiv, container);
      }); // <-- Missing closing parenthesis here

      // Append the row div to the container
      container.appendChild(rowDiv);
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
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
      displayExamDetails(exam, token);
    })
    .catch(error => {
      console.error('Fetch error:', error);
    });
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