require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    it '#vendor_count' do
      market1 = create(:market)
      market2 = create(:market)
      vendors = create_list(:vendor, 5)

      create(:market_vendor, market_id: market1.id, vendor_id: vendors[0].id)
      create(:market_vendor, market_id: market1.id, vendor_id: vendors[1].id)
      create(:market_vendor, market_id: market1.id, vendor_id: vendors[2].id)

      create(:market_vendor, market_id: market2.id, vendor_id: vendors[3].id)
      create(:market_vendor, market_id: market2.id, vendor_id: vendors[4].id)

      expect(market1.vendor_count).to eq(3)
      expect(market2.vendor_count).to eq(2)
    end
  end
end
