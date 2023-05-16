# app/controllers/api/v0/markets_controller.rb

class Api::V0::MarketsController < ApplicationController
  def index
    render(json: MarketSerializer.new(Market.all))
  end

  def show
    market = Market.find_by_id(params[:id])
    if market.nil?
      render json: {
               "errors": [
                 {
                   "detail": "Couldn't find Market with 'id'=#{params[:id]}"
                 }
               ]
             },
             status: 404
    else
      render(json: MarketSerializer.new(Market.find(params[:id])))
    end
  end
end
