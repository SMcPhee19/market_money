class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by_id(params[:market_id])
    if market.nil?
      render json: {
               "errors": [
                 {
                   "detail": "Couldn't find Market with 'id'=#{params[:market_id]}"
                 }
               ]
             },
             status: 404
    else
      render(json: VendorSerializer.new(market.vendors))
    end
  end
end