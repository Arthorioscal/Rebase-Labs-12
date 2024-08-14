require 'spec_helper'

RSpec.describe 'User Access Index Page', type: :system, js: true do
  it 'with success and exhibits the exam list' do
    visit '/'

    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('CPF: 048.973.170-88')
    expect(page).to have_content('Email: gerald.crona@ebert-quigley.com')
    expect(page).to have_content('Médico')
    expect(page).to have_content('Nome: Maria Luiza Pires')
    expect(page).to have_content('CRM: B000BJ20J4 - PI')
    expect(page).to have_content('Resultados dos Exames')
    expect(page).to have_content('Tipo: hemácias')
    expect(page).to have_content('Limites: 45-52')
    expect(page).to have_content('Resultado: 97')
    expect(page).to have_content('Juliana dos Reis Filho')
    expect(page).to have_content('Nome: Maria Helena Ramalho')
    expect(page).to have_content('Matheus Barroso')
  end

  it 'and tries with success to search for exam with a token' do
    visit '/'

    fill_in 'search-input', with: 'IQCZ17'
    click_on 'Search'

    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('CPF: 048.973.170-88')
    expect(page).to have_content('Email: gerald.crona@ebert-quigley.com')
    expect(page).to have_content('Médico')
    expect(page).to have_content('Nome: Maria Luiza Pires')
    expect(page).to have_content('CRM: B000BJ20J4 - PI')
    expect(page).to have_content('Resultados dos Exames')
    expect(page).to have_content('Tipo: hemácias')
    expect(page).to have_content('Limites: 45-52')
    expect(page).to have_content('Resultado: 97')
    expect(page).not_to have_content('Juliana dos Reis Filho')
    expect(page).not_to have_content('Nome: Maria Helena Ramalho')
    expect(page).not_to have_content('Matheus Barroso')
  end

  it 'and tries with success to import the data' do
    visit '/'
    click_on 'Import Exams'
    page.accept_alert 'Data imported successfully'

    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('CPF: 048.973.170-88')
    expect(page).to have_content('Email: gerald.crona@ebert-quigley.com')
    expect(page).to have_content('Médico')
  end
end
