require 'rails_helper'

RSpec.describe MarketsFacade do
  describe 'class methods' do
    it '#market_search' do
      market1 = create(:market, name: 'The Rooftop', city: 'Denver', state: 'Colorado')
      market2 = create(:market, name: 'Whispering Willow Market', city: 'Riverside', state: 'California')

      expect(MarketsFacade.market_search('The Rooftop', 'Denver', 'Colorado')).to eq([market1])
      expect(MarketsFacade.market_search('The Rooftop', 'Denver', 'Colorado')).to_not eq([market2])
      expect(MarketsFacade.market_search('Whispering Willow Market', 'Riverside', 'California')).to eq([market2])
      expect(MarketsFacade.market_search('Whispering Willow Market', 'Riverside', 'California')).to_not eq([market1])
    end
  end
end
