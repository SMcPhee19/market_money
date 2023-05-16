# frozen_string_literal: true

module Api
  module V0
    class VendorsController < ApplicationController
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

      def show
        vendor = Vendor.find_by_id(params[:id])
        if vendor.nil?
          render json: {
                   "errors": [
                     {
                       "detail": "Couldn't find Vendor with 'id'=#{params[:id]}"
                     }
                   ]
                 },
                 status: 404
        else
          render(json: VendorSerializer.new(Vendor.find(params[:id])))
        end
      end
    end
  end
end
