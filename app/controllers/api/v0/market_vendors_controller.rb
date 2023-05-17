module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        market_vendor = MarketVendor.new(market_vendor_params)
        return unless market_vendor.save

        render json: MarketVendorSerializer.new(MarketVendor.create(market_vendor_params)), status: 201
      end

      private

      def market_vendor_params
        params.require(:market_vendor).permit(:market_id, :vendor_id)
      end
    end
  end
end
