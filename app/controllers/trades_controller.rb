class TradesController < ApplicationController
  include Errors

  class TradeInvalid < StandardError
    attr_accessor :reason
    def initialize(reason)
      @reason = reason
    end
  end

  rescue_from TradeInvalid do |e|
    source = { reason: e.reason }
    new_error(:INVALID_TRADE, 'Invalid Trade', source)
  end

  def update
    offer = {
      idSurvivor: params[:idSurvivorFrom],
      inventory: params[:inventory_offer]
    }
    request = {
      idSurvivor: params[:idSurvivorTo],
      inventory: params[:inventory_request]
    }
    Inventory.transaction do
      @resp = TradeService.trade(offer, request)
    end
    render json: @resp, status: :ok
  end

  def trade_params
    params.require(:trade).permit(
      :inventory_offer,
      :inventory_request
    )
  end
end
