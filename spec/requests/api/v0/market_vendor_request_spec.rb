# spec/requests/api/v0/market_vendor_request_spec.rb
require 'rails_helper'

describe 'creating a market vendor' do
  it 'happy path' do
    market = create(:market)
    market2 = create(:market)
    vendor = create(:vendor)
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
  end
end
