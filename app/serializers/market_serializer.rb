# frozen_string_literal: true

# app/serializers/market_serializer.rb

class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count

  has_many :market_vendors
  has_many :vendors, through: :market_vendors
end
