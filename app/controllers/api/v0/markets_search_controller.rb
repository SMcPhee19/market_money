class Api::V0::MarketsSearchController < ApplicationController
  before_action :valid_params, only: :index

  def index
    @markets = MarketsFacade.market_search(params[:name], params[:city], params[:state])
    render json: MarketSerializer.new(@markets)
  end

  private

  def valid_params
    return unless only_city? || just_city_and_name?

    invalid_response
  end

  def only_city?
    params[:city].present? && !params[:name].present? && !params[:state].present?
  end

  def just_city_and_name?
    params[:city].present? && params[:name].present? && !params[:state].present?
  end

  def invalid_response
    render json: { "errors": [{ "detail": 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.' }] },
           status: 422
  end
end
