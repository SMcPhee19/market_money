# frozen_string_literal: true

class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :vendor_id, uniqueness: { scope: :market_id }
  validates :market_id, uniqueness: { scope: :vendor_id}

  def self.find_market_vendor(market_id, vendor_id)
    MarketVendor.where(market_id: market_id, vendor_id: vendor_id).first
  end
end
