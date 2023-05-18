# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  before(:each) do
    market = create(:market)
    vendor = create(:vendor)

    create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
  end

  describe 'relationships' do
    it { should belong_to :market }
    it { should belong_to :vendor }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:market_id).scoped_to(:vendor_id) }
    it { is_expected.to validate_uniqueness_of(:vendor_id).scoped_to(:market_id) }
  end

  describe 'class methods' do
    it '::find_market_vendor' do
      market1 = create(:market)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
      vendor4 = create(:vendor)

      mv1 = create(:market_vendor, market_id: market1.id, vendor_id: vendor2.id)
      mv2 = create(:market_vendor, market_id: market1.id, vendor_id: vendor3.id)

      expect(MarketVendor.find_market_vendor(market1.id, vendor2.id)).to eq(mv1)
    end
  end
end
