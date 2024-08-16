require 'spec_helper'

RSpec.describe 'User Access Index Page', type: :system, js: true do
  before do
    mock_path = File.expand_path('../support/mock.json', __dir__)
    mock = JSON.parse(File.read(mock_path))
    allow(Faraday).to receive(:get).and_return(double(body: mock.to_json))
  end

  it 'with success and exhibits the exam list in the first page' do
    visit '/'

    expect(page).to have_content('Paciente:')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Maria Luiza Pires')

    expect(page).to have_content('Juliana dos Reis Filho')
    expect(page).to have_content('Maria Helena Ramalho')

    expect(page).to have_content('Matheus Barroso')
    expect(page).to have_content('Sra. Calebe Louzada')

    expect(page).to have_content('Patricia Gentil')
    expect(page).to have_content('Dra. Isabelly Rêgo')

    expect(page).to have_content('Ígor Moura')
    expect(page).to have_content('Maria Luiza Pires')

    expect(page).to have_content('João Samuel Garcês')
    expect(page).to have_content('Ana Sophia Aparício Neto')

    expect(page).to have_content('João Guilherme Palmeira')
    expect(page).to have_content('Núbia Godins')

    expect(page).to have_content('Deneval Caseira')
    expect(page).to have_content('Maria Helena Ramalho')

    expect(page).to have_content('João Samuel Garcês')
    expect(page).to have_content('Dra. Isabelly Rêgo')
  end

  it 'and changes page' do
    visit '/'
    click_on 'Próximo'

    expect(page).to have_content('Paciente:')
    expect(page).to have_content('Vitor Hugo Gomes Neto')
    expect(page).to have_content('Z95COQ')
    expect(page).to have_content('Dra. Isabelly Rêgo')
    expect(page).to have_content('Giovanna Rêgo')
    expect(page).to have_content('29/10/2021')
    expect(page).not_to have_content('Emilly Batista Neto')
    expect(page).not_to have_content('IQCZ17')
    expect(page).not_to have_content('Deneval Caseira')
  end
end
