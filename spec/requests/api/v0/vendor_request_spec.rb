# spec/requests/api/v0/vendor_request_spec.rb
require 'rails_helper'

describe '/api/v0/vendors' do
  it 'sends a list of all vendors, happy' do
    market1 = create(:market)

    vendors = create_list(:vendor, 10)

    create(:market_vendor, market_id: market1.id, vendor_id: vendors[0].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[1].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[2].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[3].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[4].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[5].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[6].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[7].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[8].id)
    create(:market_vendor, market_id: market1.id, vendor_id: vendors[9].id)

    get '/api/v0/markets/:id/vendors'

    expect(response).to be_successful

    all_vendors = JSON.parse(response.body, symbolize_names: true)

    expect(all_vendors[:data].count).to eq(10)

    all_vendors[:data].each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)
      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to eq('vendor')
      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)
      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)
      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)
      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)
      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
    end
  end
end