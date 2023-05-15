# spec/requests/api/v0/market_request_spec.rb
require 'rails_helper'

describe 'Market API' do
  it 'sends a list of all markets' do
    create_list(:market, 10)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data].count).to eq(10)

    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)
      expect(market).to have_key(:type)
      expect(market[:type]).to eq('market')
      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)
      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)
      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)
      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)
    end
  end

  it 'can return a new attribute, vendor_count' do
    market1 = create(:market)
    market2 = create(:market)
    vendors = create_list(:vendor, 5, market: market1)
    vendors = create_list(:vendor, 3, market: market2)

    get '/api/v0/markets'

    markets = JSON.parse(response.body, symbolize_names: true)
require 'pry'; binding.pry
    expect(markets[:data][0][:attributes]).to have_key(:vendor_count)
    expect(markets[:data][0][:attributes][:vendor_count]).to eq(5)
    expect(markets[:data][1][:attributes]).to have_key(:vendor_count)
    expect(markets[:data][1][:attributes][:vendor_count]).to eq(3)
  end
end