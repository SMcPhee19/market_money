module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        vendor = Vendor.find_by_id(params[:market_vendor][:vendor_id])
        market = Market.find_by_id(params[:market_vendor][:market_id])
        market_vendor = MarketVendor.new(market:, vendor:)

        if market_vendor.save
          render json: MarketVendorSerializer.new(market_vendor), status: 201
        elsif market.nil? || vendor.nil?
          render json: { "errors": [{ "detail": "Validation failed: vendor or market doesn't exist" }] }, status: 404
        else
          render json: { "errors": [{ "detail": "Validation failed: Market vendor asociation between market with market_id=#{params[:market_vendor][:market_id]} and vendor_id=#{params[:market_vendor][:vendor_id]} already exists" }] },
                 status: 422
        end
      end

      def destroy
        vendor = Vendor.find_by_id(params[:market_vendor][:vendor_id])
        market = Market.find_by_id(params[:market_vendor][:market_id])
        market_vendor = MarketVendor.find_market_vendor(market, vendor)
        if vendor.nil? || market.nil?
          render json: { "errors": [{ "detail": "No MarketVendor with market_id=#{params[:market_vendor][:market_id]} and vendor_id=#{params[:market_vendor][:vendor_id]} exists" }] }, status: 404
        else
          market_vendor.destroy
        end
      end

      private

      def market_vendor_params
        params.require(:market_vendor).permit(:market_id, :vendor_id)
      end
    end
  end
end
