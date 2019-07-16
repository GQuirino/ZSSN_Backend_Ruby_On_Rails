class TradesController < ApplicationController
  include Errors
  rescue_from SurvivorInfectedError, with: :render_survivor_infected
  rescue_from TradeInvalidError, with: :render_trade_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :render_resource_not_found

  def update
    render json: TradeService.trade(offer_params, requester_params), status: :ok
  end

  private

  def offer_params
    {
      id_survivor: params.require(:id_survivor_from),
      inventory: params.require(:inventory_offer)
    }
  end

  def requester_params
    {
      id_survivor: params.require(:id_survivor_to),
      inventory: params.require(:inventory_request)
    }
  end
end
