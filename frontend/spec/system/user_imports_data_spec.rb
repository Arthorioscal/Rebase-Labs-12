require 'spec_helper'

RSpec.describe 'User Imports Data', type: :system, js: true do
  it 'successfully' do
    response_body = { message: 'Importando Dados, aguarde um momento.' }.to_json
    conn = double('Faraday::Connection')
    response = double('Faraday::Response', success?: true, body: response_body)
    allow(conn).to receive(:post).and_return(response)
    allow(Faraday).to receive(:new).and_return(conn)
    mock_path = File.expand_path('../support/mock.json', __dir__)
    mock = JSON.parse(File.read(mock_path))
    allow(Faraday).to receive(:get).and_return(double(body: mock.to_json))

    visit '/'

    find('#file-input', visible: false).set(File.expand_path('spec/support/reduced_data.csv'))
    click_on 'Importar Dados'
    sleep 3
    accept_alert 'Importando Dados, aguarde um momento.'

    expect(page).to have_content('Paciente:')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Maria Luiza Pires')
  end
end
