import { createCard } from './card.js';
export let allExams = [];
export let currentPage = 1;
const examsPerPage = 10;

export function displayPage(page) {
  const container = document.getElementById('exams-container');
  container.innerHTML = '';
  const rowDiv = document.createElement('div');
  rowDiv.className = 'row';

  const startIndex = (page - 1) * examsPerPage;
  const endIndex = page * examsPerPage;
  const examsToDisplay = allExams.slice(startIndex, endIndex);

  examsToDisplay.forEach(exam => {
    createCard(exam, rowDiv, container);
  });

  container.appendChild(rowDiv);
  updatePaginationControls();
}

export function updatePaginationControls() {
  const totalPages = Math.ceil(allExams.length / examsPerPage);
  const paginationContainer = document.getElementById('pagination-controls');
  paginationContainer.innerHTML = '';

  const prevButton = document.createElement('button');
  prevButton.innerHTML = '&larr; Voltar';
  prevButton.className = 'btn btn-primary mx-2 mb-1';
  prevButton.disabled = currentPage === 1;
  prevButton.addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      displayPage(currentPage);
    }
  });

  const nextButton = document.createElement('button');
  nextButton.innerHTML = 'Próximo &rarr;';
  nextButton.className = 'btn btn-primary mx-2 mb-1';
  nextButton.disabled = currentPage === totalPages;
  nextButton.addEventListener('click', () => {
    if (currentPage < totalPages) {
      currentPage++;
      displayPage(currentPage);
    }
  });

  paginationContainer.appendChild(prevButton);
  paginationContainer.appendChild(nextButton);
}