require 'rspec'
require 'net/http'
require 'json'
require 'csv'
require_relative '../api/api'

RSpec.describe 'Exchange Rate API' do
  let(:base_currency) { 'USD' }
  let(:url) { URI.parse("https://v6.exchangerate-api.com/v6/401c49c60de22d97d8b7761a/latest/#{base_currency}") }

  let(:mock_response) { '{"result": "success", "conversion_rates": {"EUR": 0.85, "GBP": 0.75}}' }

  before do
    allow(Net::HTTP).to receive(:get).with(url).and_return(mock_response)
    allow(CSV).to receive(:open)
  end

  it 'перевіряє, чи повертається успішна відповідь від API' do
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    expect(data['result']).to eq('success')
  end

  it 'перевіряє правильність структури даних' do
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    expect(data).to have_key('conversion_rates')
    expect(data['conversion_rates']).to have_key('EUR')
    expect(data['conversion_rates']['EUR']).to eq(0.85)
    expect(data['conversion_rates']['GBP']).to eq(0.75)
  end

  it 'перевіряє створення CSV файлу з правильними даними' do
    expect(CSV).to receive(:open).with('output/exchange_rates.csv', 'w')

    save_exchange_rates(mock_response)
  end
end

