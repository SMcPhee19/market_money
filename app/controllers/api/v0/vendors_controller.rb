class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by_id(params[:market_id])
    render(json: VendorSerializer.new(market.vendors))
  end
end