# frozen_string_literal: true

class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :vendor_id, uniqueness: { scope: :market_id }
end
