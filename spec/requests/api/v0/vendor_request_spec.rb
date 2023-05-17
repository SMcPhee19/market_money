# frozen_string_literal: true

# spec/requests/api/v0/vendor_request_spec.rb
require 'rails_helper'

describe 'Sends a list of all vendors' do
  it 'happy path' do
    market1 = create(:market)
    market2 = create(:market)

    vendors = create_list(:vendor, 11)

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
    create(:market_vendor, market_id: market2.id, vendor_id: vendors[10].id)

    get "/api/v0/markets/#{market1.id}/vendors"

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

  it 'sad path' do
    get '/api/v0/markets/1223123123123123123'

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(market[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=1223123123123123123")
  end
end

describe 'sends a single vendor' do
  it 'happy path' do
    market1 = create(:market)
    vendor1 = create(:vendor,
                     name: 'Urban Harvest',
                     description: 'Urban Harvest is a non-profit organization',
                     contact_name: 'Bob',
                     contact_phone: '303-555-5555',
                     credit_accepted: true)

    create(:market_vendor, market_id: market1.id, vendor_id: vendor1.id)

    get "/api/v0/vendors/#{vendor1.id}"

    expect(response).to be_successful

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(vendor.count).to eq(1)
    expect(vendor[:data][:id]).to eq(vendor1.id.to_s)
    expect(vendor[:data][:type]).to eq('vendor')
    expect(vendor[:data][:attributes][:name]).to eq('Urban Harvest')
    expect(vendor[:data][:attributes][:description]).to eq('Urban Harvest is a non-profit organization')
    expect(vendor[:data][:attributes][:contact_name]).to eq('Bob')
    expect(vendor[:data][:attributes][:contact_phone]).to eq('303-555-5555')
    expect(vendor[:data][:attributes][:credit_accepted]).to eq(true)
  end

  it 'sad path' do
    get '/api/v0/vendors/8454665744'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(response.body).to eq("{\"errors\":[{\"detail\":\"Couldn't find Vendor with 'id'=8454665744\"}]}")
  end
end

describe 'Creates a new vendor' do
  it 'happy path' do
    valid_attributes = {
      vendor: {
        name: 'Kakariko Village Bazaar',
        description: "It's dangerous to go alone! Take this.",
        contact_name: 'Rhoam Bosphoramus Hyrule',
        contact_phone: '322-498-4456',
        credit_accepted: true
      }
    }

    post '/api/v0/vendors', params: valid_attributes

    expect(response).to be_successful
    expect(response.status).to eq(201)

    new_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(new_vendor.count).to eq(1)
    expect(new_vendor[:data][:id]).to be_a(String)
    expect(new_vendor[:data][:id]).to eq(Vendor.last.id.to_s)
    expect(new_vendor[:data][:type]).to be_a(String)
    expect(new_vendor[:data][:type]).to eq('vendor')
    expect(new_vendor[:data][:attributes]).to have_key(:name)
    expect(new_vendor[:data][:attributes][:name]).to be_a(String)
    expect(new_vendor[:data][:attributes][:name]).to eq('Kakariko Village Bazaar')
    expect(new_vendor[:data][:attributes]).to have_key(:description)
    expect(new_vendor[:data][:attributes][:description]).to be_a(String)
    expect(new_vendor[:data][:attributes][:description]).to eq("It's dangerous to go alone! Take this.")
    expect(new_vendor[:data][:attributes]).to have_key(:contact_name)
    expect(new_vendor[:data][:attributes][:contact_name]).to be_a(String)
    expect(new_vendor[:data][:attributes][:contact_name]).to eq('Rhoam Bosphoramus Hyrule')
    expect(new_vendor[:data][:attributes]).to have_key(:contact_phone)
    expect(new_vendor[:data][:attributes][:contact_phone]).to be_a(String)
    expect(new_vendor[:data][:attributes][:contact_phone]).to eq('322-498-4456')
    expect(new_vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect(new_vendor[:data][:attributes][:credit_accepted]).to be_in([true, false])
    expect(new_vendor[:data][:attributes][:credit_accepted]).to eq(true)
  end

  it 'sad path' do
    invalid_attributes = {
      name: 'Kakariko Village Bazaar'
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v0/vendors', headers:, params: JSON.generate(vendor: invalid_attributes)

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(vendor[:errors][0][:detail]).to eq('Param is missing or the value is empty: vendor')
  end

  describe 'Udpate a vendor' do
    it 'happy path' do
      vendor1 = create(:vendor,
                       name: 'Kakario Village Bazaar',
                       description: "It's dangerous to go alone! Take this.",
                       contact_name: 'Rhoam Bosphoramus Hyrule',
                       contact_phone: '322-498-4456',
                       credit_accepted: true)

      update_params = {
        vendor: {
          name: 'Kakariko Village Bazaar',
          description: 'Shadow and light are two sides of the same coin... One cannot exist without the other.',
          contact_name: 'Princess Midna',
          contact_phone: '322-498-4456',
          credit_accepted: true
        }
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{vendor1.id}", params: update_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(updated_vendor[:data][0][:attributes][:name]).to eq('Kakariko Village Bazaar')

      expect(updated_vendor[:data][0][:attributes][:description]).to eq('Shadow and light are two sides of the same coin... One cannot exist without the other.')
      expect(updated_vendor[:data][0][:attributes][:description]).to_not eq("It's dangerous to go alone! Take this.")

      expect(updated_vendor[:data][0][:attributes][:contact_name]).to eq('Princess Midna')
      expect(updated_vendor[:data][0][:attributes][:contact_name]).to_not eq('Rhoam Bosphoramus Hyrule')

      expect(updated_vendor[:data][0][:attributes][:contact_phone]).to eq('322-498-4456')
      expect(updated_vendor[:data][0][:attributes][:credit_accepted]).to eq(true)
    end

    it 'sad path: invalid id' do
      get '/api/v0/vendors/8454665744'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to eq("{\"errors\":[{\"detail\":\"Couldn't find Vendor with 'id'=8454665744\"}]}")
    end

    it 'sad path: invalid params' do
      vendor1 = create(:vendor,
                       name: 'Kakario Village Bazaar',
                       description: "It's dangerous to go alone! Take this.",
                       contact_name: 'Rhoam Bosphoramus Hyrule',
                       contact_phone: '322-498-4456',
                       credit_accepted: true)

      update_params = {
        vendor: {
          contact_name: nil
        }
      }

      patch "/api/v0/vendors/#{vendor1.id}", params: update_params

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(vendor[:errors][0][:detail]).to eq('Param is missing or the value is empty: vendor')
    end
  end

  describe 'Delete a vendor' do
    it 'happy path' do
      vendor1 = create(:vendor)

      delete "/api/v0/vendors/#{vendor1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Vendor.count).to eq(0)
      expect { Vendor.find(vendor1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'sad path: invalid id' do
      delete '/api/v0/vendors/7089587281'

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to eq("{\"errors\":[{\"detail\":\"Couldn't find Vendor with 'id'=7089587281\"}]}")
    end
  end
end
