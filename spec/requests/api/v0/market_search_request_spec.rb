require 'rails_helper'

RSpec.describe 'Market Search' do
  describe 'happy paths' do
    it 'returns a market: all three params' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        name: 'The Rooftop',
        city: 'Denver',
        state: 'Colorado'
      }

      get '/api/v0/markets/search', params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      searched = JSON.parse(response.body, symbolize_names: true)

      expect(searched[:data].count).to eq(1)
      expect(searched[:data][0][:attributes][:name]).to eq(market1.name)
      expect(searched[:data][0][:attributes][:name]).to_not eq(market2.name)
      expect(searched[:data][0][:attributes][:city]).to eq(market1.city)
      expect(searched[:data][0][:attributes][:city]).to_not eq(market2.city)
      expect(searched[:data][0][:attributes][:state]).to eq(market1.state)
      expect(searched[:data][0][:attributes][:state]).to_not eq(market2.state)
    end

    it 'returns a market: two params(city and state)' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        city: 'Denver',
        state: 'Colorado'
      }

      get '/api/v0/markets/search', params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      searched = JSON.parse(response.body, symbolize_names: true)

      expect(searched[:data].count).to eq(1)
      expect(searched[:data][0][:attributes][:name]).to eq(market1.name)
      expect(searched[:data][0][:attributes][:name]).to_not eq(market2.name)
      expect(searched[:data][0][:attributes][:city]).to eq(market1.city)
      expect(searched[:data][0][:attributes][:city]).to_not eq(market2.city)
      expect(searched[:data][0][:attributes][:state]).to eq(market1.state)
      expect(searched[:data][0][:attributes][:state]).to_not eq(market2.state)
    end

    it 'returns a market: two params(state and name)' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        name: 'The Rooftop',
        state: 'Colorado'
      }

      get '/api/v0/markets/search', params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      searched = JSON.parse(response.body, symbolize_names: true)

      expect(searched[:data].count).to eq(1)
      expect(searched[:data][0][:attributes][:name]).to eq(market1.name)
      expect(searched[:data][0][:attributes][:name]).to_not eq(market2.name)
      expect(searched[:data][0][:attributes][:city]).to eq(market1.city)
      expect(searched[:data][0][:attributes][:city]).to_not eq(market2.city)
      expect(searched[:data][0][:attributes][:state]).to eq(market1.state)
      expect(searched[:data][0][:attributes][:state]).to_not eq(market2.state)
    end

    it 'returns a market: one params(state)' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        state: 'Colorado'
      }

      get '/api/v0/markets/search', params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      searched = JSON.parse(response.body, symbolize_names: true)

      expect(searched[:data].count).to eq(1)
      expect(searched[:data][0][:attributes][:name]).to eq(market1.name)
      expect(searched[:data][0][:attributes][:name]).to_not eq(market2.name)
      expect(searched[:data][0][:attributes][:city]).to eq(market1.city)
      expect(searched[:data][0][:attributes][:city]).to_not eq(market2.city)
      expect(searched[:data][0][:attributes][:state]).to eq(market1.state)
      expect(searched[:data][0][:attributes][:state]).to_not eq(market2.state)
    end

    it 'returns a market: one params(name)' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        name: 'The Rooftop'
      }

      get '/api/v0/markets/search', params: query_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      searched = JSON.parse(response.body, symbolize_names: true)

      expect(searched[:data].count).to eq(1)
      expect(searched[:data][0][:attributes][:name]).to eq(market1.name)
      expect(searched[:data][0][:attributes][:name]).to_not eq(market2.name)
      expect(searched[:data][0][:attributes][:city]).to eq(market1.city)
      expect(searched[:data][0][:attributes][:city]).to_not eq(market2.city)
      expect(searched[:data][0][:attributes][:state]).to eq(market1.state)
      expect(searched[:data][0][:attributes][:state]).to_not eq(market2.state)
    end
  end

  describe 'sad paths' do
    it 'fails if only city is given' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        city: 'Denver'
      }

      get '/api/v0/markets/search', params: query_params
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      
      invalid = JSON.parse(response.body, symbolize_names: true)

      expect(invalid).to have_key(:errors)
      expect(invalid[:errors][0][:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
    end

    it 'fails if only city and name is given' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      query_params = {
        name: 'The Rooftop',
        city: 'Denver'
      }

      get '/api/v0/markets/search', params: query_params
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      
      invalid = JSON.parse(response.body, symbolize_names: true)

      expect(invalid).to have_key(:errors)
      expect(invalid[:errors][0][:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
    end
  end
end