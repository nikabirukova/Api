require 'net/http'
require 'json'
require 'csv'
require 'uri'
require 'fileutils'

def save_exchange_rates(response)
  data = JSON.parse(response)
  exchange_rates = data['conversion_rates']

  FileUtils.mkdir_p('output')

  CSV.open('output/exchange_rates.csv', 'w') do |csv|
    csv << ['Currency', 'Exchange Rate']
    exchange_rates.each do |currency, rate|
      csv << [currency, rate]
    end
  end
  puts "Дані успішно збережено в файл output/exchange_rates.csv"
end

base_currency = 'USD'

url = URI.parse("https://v6.exchangerate-api.com/v6/401c49c60de22d97d8b7761a/latest/#{base_currency}")
response = Net::HTTP.get(url)

data = JSON.parse(response)

if data['result'] == 'success'
  save_exchange_rates(response)
else
  puts "Помилка: #{data['error-type']}"
end

