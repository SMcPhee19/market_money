# spec/requests/api/v0/market_vendor_request_spec.rb
require 'rails_helper'

describe 'creating a market vendor' do
  it 'happy path' do
    market = create(:market, name: 'Union Station Farmers Market')
    market2 = create(:market)
    vendor = create(:vendor, name: 'Acme Farms')
    vendor2 = create(:vendor)

    market_vendor_params = { market_id: market.id, vendor_id: vendor.id }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v0/market_vendors', headers:, params: JSON.generate(market_vendor: market_vendor_params)

    expect(response).to be_successful
    expect(response.status).to eq(201)

    new_mv = JSON.parse(response.body, symbolize_names: true)

    expect(new_mv).to have_key(:data)
    expect(new_mv[:data]).to be_a(Hash)
    expect(new_mv[:data]).to have_key(:id)
    expect(new_mv[:data]).to have_key(:type)
    expect(new_mv[:data]).to have_key(:relationships)
    expect(new_mv[:data][:relationships]).to have_key(:market)
    expect(new_mv[:data][:relationships][:market][:data]).to have_key(:id)
    expect(new_mv[:data][:relationships][:market][:data][:id]).to eq(market.id.to_s)
    expect(new_mv[:data][:relationships][:market][:data][:id]).to_not eq(market2.id.to_s)
    expect(new_mv[:data][:relationships][:vendor][:data]).to have_key(:id)
    expect(new_mv[:data][:relationships][:vendor][:data][:id]).to eq(vendor.id.to_s)
    expect(new_mv[:data][:relationships][:vendor][:data][:id]).to_not eq(vendor2.id.to_s)

    get "/api/v0/markets/#{market.id}/vendors"

    market_vendors = JSON.parse(response.body, symbolize_names: true)

    expect(market_vendors[:data].count).to eq(1)
    expect(market_vendors[:data][0]).to have_key(:attributes)
    expect(market_vendors[:data][0][:attributes][:name]).to eq(vendor.name)
    expect(market_vendors[:data][0][:attributes][:name]).to_not eq(vendor2.name)
    expect(market_vendors[:data][0][:attributes][:description]).to eq(vendor.description)
    expect(market_vendors[:data][0][:attributes][:description]).to_not eq(vendor2.description)
  end

  it 'sad path: market does not exist' do
    vendor1 = create(:vendor)

    mv_params = { "market_id": nil, "vendor_id": vendor1.id }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v0/market_vendors', headers:, params: JSON.generate(market_vendor: mv_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    invalid = JSON.parse(response.body, symbolize_names: true)

    expect(invalid).to have_key(:errors)
    expect(invalid[:errors][0][:detail]).to eq("Validation failed: vendor or market doesn't exist")
  end

  it 'sad path: vendor does not exist' do
    market1 = create(:market)

    mv_params = { "market_id": market1.id, "vendor_id": nil }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v0/market_vendors', headers:, params: JSON.generate(market_vendor: mv_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    invalid = JSON.parse(response.body, symbolize_names: true)

    expect(invalid).to have_key(:errors)
    expect(invalid[:errors][0][:detail]).to eq("Validation failed: vendor or market doesn't exist")
  end

  it 'sad path: association already exists' do
    market1 = create(:market)
    vendor1 = create(:vendor)

    create(:market_vendor, market_id: market1.id, vendor_id: vendor1.id)

    mv_params = { "market_id": market1.id, "vendor_id": vendor1.id }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v0/market_vendors', headers:, params: JSON.generate(market_vendor: mv_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(422)

    invalid = JSON.parse(response.body, symbolize_names: true)

    expect(invalid).to have_key(:errors)
    expect(invalid[:errors][0][:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market1.id} and vendor_id=#{vendor1.id} already exists")
  end
end
