module Api
  module V0
    class AtmsController < ApplicationController
      def index
        market = Market.find_by_id(params[:market_id])

        if market.nil?
          render json: { "errors": [{ "detail": "Couldn't find Market with 'id'=#{params[:market_id]}" }] }, status: 404
        else
          atms = TomTomFacade.new(market).atms
          render json: AtmSerializer.new(atms)
        end
      end
    end
  end
end