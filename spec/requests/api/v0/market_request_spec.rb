# frozen_string_literal: true

# spec/requests/api/v0/market_request_spec.rb
require 'rails_helper'

describe '/api/v0/markets' do
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
    vendors = create_list(:vendor, 5)

    create(:market_vendor, market_id: market1.id, vendor_id: vendors[0].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[1].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[2].id)

    create(:market_vendor, market_id: market2.id, vendor_id: vendors[3].id)
    create(:market_vendor, market_id: market2.id, vendor_id: vendors[4].id)

    get '/api/v0/markets'

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data][0][:attributes]).to have_key(:vendor_count)
    expect(markets[:data][0][:attributes][:vendor_count]).to be_an(Integer)
    expect(markets[:data][0][:attributes][:vendor_count]).to eq(3)
    expect(markets[:data][1][:attributes]).to have_key(:vendor_count)
    expect(markets[:data][1][:attributes][:vendor_count]).to be_an(Integer)
    expect(markets[:data][1][:attributes][:vendor_count]).to eq(2)
  end

  describe 'sends a single market' do
    it 'happy path' do
      market1 = create(:market,
                       name: 'Union Station Farmers Market',
                       street: '1701 Wynkoop St',
                       city: 'Denver',
                       county: 'Denver',
                       state: 'Colorado',
                       zip: '80202',
                       lat: '39.752723',
                       lon: '-104.998275')
      vendors = create_list(:vendor, 1)

      create(:market_vendor, market_id: market1.id, vendor_id: vendors[0].id)

      get "/api/v0/markets/#{market1.id}"

      market = JSON.parse(response.body, symbolize_names: true)

      expect(market.count).to eq(1)
      expect(market[:data][:id]).to eq(market1.id.to_s)
      expect(market[:data][:type]).to eq('market')
      expect(market[:data][:attributes][:name]).to eq('Union Station Farmers Market')
      expect(market[:data][:attributes][:street]).to eq('1701 Wynkoop St')
      expect(market[:data][:attributes][:city]).to eq('Denver')
      expect(market[:data][:attributes][:county]).to eq('Denver')
      expect(market[:data][:attributes][:county]).to eq('Denver')
      expect(market[:data][:attributes][:state]).to eq('Colorado')
      expect(market[:data][:attributes][:zip]).to eq('80202')
      expect(market[:data][:attributes][:lat]).to eq('39.752723')
      expect(market[:data][:attributes][:lon]).to eq('-104.998275')
      expect(market[:data][:attributes][:vendor_count]).to eq(1)
    end

    it 'sad path' do
      get '/api/v0/markets/1223123123123123123'

      market = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(market[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1223123123123123123")
    end
  end

  describe 'atms: happy paths' do
    it 'returns atms close to market' do
      VCR.use_cassette('can_create_a_connection_and_get_atms') do
        market1 = create(:market, lat: '39.752723', lon: '-104.998275')

        get "/api/v0/markets/#{market1.id}/nearest_atms"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        atms = JSON.parse(response.body, symbolize_names: true)

        expect(atms[:data]).to be_an(Array)
        expect(atms[:data].count).to eq(10)
        expect(atms[:data][0]).to have_key(:type)
        expect(atms[:data][0][:type]).to eq('atm')
        expect(atms[:data][0]).to have_key(:attributes)
        expect(atms[:data][0][:attributes]).to be_a(Hash)
        expect(atms[:data][0][:attributes]).to have_key(:name)
        expect(atms[:data][0][:attributes][:name]).to be_a(String)
        expect(atms[:data][0][:attributes]).to have_key(:address)
        expect(atms[:data][0][:attributes][:address]).to be_a(String)
        expect(atms[:data][0][:attributes]).to have_key(:lat)
        expect(atms[:data][0][:attributes][:lat]).to be_a(Float)
        expect(atms[:data][0][:attributes]).to have_key(:lon)
        expect(atms[:data][0][:attributes][:lon]).to be_a(Float)
        expect(atms[:data][0][:attributes]).to have_key(:distance)
        expect(atms[:data][0][:attributes][:distance]).to be_a(Float)
      end
    end

    it 'sad path: invalid market id' do
      VCR.use_cassette('can_create_a_connection_and_get_atms') do
        get '/api/v0/markets/120606/nearest_atms'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        invalid = JSON.parse(response.body, symbolize_names: true)

        expect(invalid[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=120606")
      end
    end
  end
end
