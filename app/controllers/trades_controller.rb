require './lib/exceptions/survivor_infected_error'
require './lib/exceptions/trade_invalid_error'

class TradesController < ApplicationController
  include Errors
  rescue_from SurvivorInfectedError, with: :render_survivor_infected
  rescue_from TradeInvalidError, with: :render_trade_invalid

  def update
    offer = {
      id_survivor: params[:id_survivor_from],
      inventory: params[:inventory_offer]
    }
    request = {
      id_survivor: params[:id_survivor_to],
      inventory: params[:inventory_request]
    }

    resp = TradeService.trade(offer, request)

    render json: resp, status: :ok
  end

  def trade_params
    params.require(:trade).permit(
      :inventory_offer,
      :inventory_request
    )
  end
end
