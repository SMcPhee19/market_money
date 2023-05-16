# frozen_string_literal: true

# app/controllers/api/v0/markets_controller.rb

module Api
  module V0
    class MarketsController < ApplicationController
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
  end
end
