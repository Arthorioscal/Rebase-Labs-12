require 'spec_helper'

RSpec.describe 'User Search For Exam', type: :system, js: true do
  it 'successfully' do
    mock_path = File.expand_path('../support/test_token.json', __dir__)
    mock = JSON.parse(File.read(mock_path))
    allow(Faraday).to receive(:get).and_return(double(body: mock.to_json))

    visit '/'

    fill_in 'search-input', with: 'T9O6AI'
    click_on 'Procurar'

    expect(page).to have_content('Nome:')
    expect(page).to have_content('Matheus Barroso')
    expect(page).to have_content('E-mail:')
    expect(page).to have_content('maricela@streich.com')
    expect(page).to have_content('Nascimento:')
    expect(page).to have_content('09/03/1972')
    expect(page).to have_content('Médico')
    expect(page).to have_content('Nome:')
    expect(page).to have_content('Sra. Calebe Louzada')
    expect(page).to have_content('CRM:')
    expect(page).to have_content('B000B7CDX4/SP')
    expect(page).to have_content('Resultados')
    expect(page).to have_content('Tipo Intervalo Resultado')
    expect(page).to have_content('hemácias 45-52 48')
    expect(page).to have_content('leucócitos 9-61 75')
    expect(page).to have_content('plaquetas 11-93 67')
    expect(page).to have_content('hdl 19-75 3')
    expect(page).to have_content('ldl 45-54 27')
    expect(page).to have_content('vldl 48-72 27')
    expect(page).to have_content('glicemia 25-83 78')
    expect(page).to have_content('tgo 50-84 15')
    expect(page).to have_content('tgp 38-63 34')
    expect(page).to have_content('eletrólitos 2-68 92')
    expect(page).to have_content('tsh 25-80 21')
    expect(page).to have_content('t4-livre 34-60 95')
    expect(page).to have_content('ácido úrico 15-61 10')
    expect(page).not_to have_content('Juliana dos Reis Filho')
    expect(page).not_to have_content('Maria Helena Ramalho')
  end

  it 'and returns error if exam is not found' do
    visit '/'

    fill_in 'search-input', with: 'EUAMOOUTERWILDS'
    click_on 'Procurar'

    expect(page).to have_content('Falha em buscar o exame. Verifique o token e tente novamente.')
  end

  it 'leave the field in blank' do
    visit '/'

    click_on 'Procurar'

    expect(page).to have_content('Por favor, insira um token válido')
  end
end
