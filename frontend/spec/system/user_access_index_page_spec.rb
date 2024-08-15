require 'spec_helper'

RSpec.describe 'User Access Index Page', type: :system, js: true do
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
    expect(page).to have_content('Sra. Meire da Terra')
    expect(page).to have_content('10/08/2021')
    expect(page).not_to have_content('Emilly Batista Neto')
    expect(page).not_to have_content('IQCZ17')
    expect(page).not_to have_content('Deneval Caseira')
  end

  it 'and tries with success to search for exam with a token' do
    visit '/'

    fill_in 'search-input', with: 'IQCZ17'
    click_on 'Procurar'

    expect(page).to have_content('Nome:')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('E-mail:')
    expect(page).to have_content('gerald.crona@ebert-quigley.com')
    expect(page).to have_content('Nascimento:')
    expect(page).to have_content('11/03/2001')
    expect(page).to have_content('Médico')
    expect(page).to have_content('Nome:')
    expect(page).to have_content('Maria Luiza Pires')
    expect(page).to have_content('CRM:')
    expect(page).to have_content('B000BJ20J4/PI')
    expect(page).to have_content('Resultados')
    expect(page).to have_content('Tipo Intervalo Resultado')
    expect(page).to have_content('hemácias 45-52 97')
    expect(page).to have_content('leucócitos 9-61 89')
    expect(page).to have_content('plaquetas 11-93 97')
    expect(page).to have_content('hdl 19-75 0')
    expect(page).to have_content('ldl 45-54 80')
    expect(page).to have_content('vldl 48-72 82')
    expect(page).to have_content('glicemia 25-83 98')
    expect(page).to have_content('tgo 50-84 87')
    expect(page).to have_content('tgp 38-63 9')
    expect(page).to have_content('eletrólitos 2-68 85')
    expect(page).to have_content('tsh 25-80 65')
    expect(page).to have_content('t4-livre 34-60 94')
    expect(page).to have_content('ácido úrico 15-61 2')
    expect(page).not_to have_content('Juliana dos Reis Filho')
    expect(page).not_to have_content('Maria Helena Ramalho')
    expect(page).not_to have_content('Matheus Barroso')
  end

  it 'and tries with success to import the data' do
    visit '/'
    click_on 'Importar Dados'
    page.accept_alert 'Importando Dados, aguarde um momento.'

    expect(page).to have_content('Paciente:')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Maria Luiza Pires')
    expect(page).to have_content('Juliana dos Reis Filho')
    expect(page).to have_content('Maria Helena Ramalho')
  end
end
