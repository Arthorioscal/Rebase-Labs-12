require 'spec_helper'

RSpec.describe 'User Imports Data', type: :system, js: true do
  it 'successfully' do
    visit '/'

    attach_file 'file-input', File.expand_path('spec/support/reduced_data.csv')
    click_on 'Importar Dados'
    sleep 3
    accept_alert 'Importando Dados, aguarde um momento.'

    expect(page).to have_content('Paciente:')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Maria Luiza Pires')
  end
end
