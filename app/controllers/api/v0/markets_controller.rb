# app/controllers/api/v0/markets_controller.rb

class Api::V0::MarketsController < ApplicationController
  def index
    render(json: MarketSerializer.new(Market.all))
  end
end
