require 'rails_helper'

RSpec.describe TomTomFacade do
  describe 'initialize' do
    it 'exists' do
      market = create(:market)
      facade = TomTomFacade.new(market)

      expect(facade).to be_a(TomTomFacade)
      expect(facade.location).to eq(market)
    end
  end
end