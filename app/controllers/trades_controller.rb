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
    # check transactions
    resp = {}
    Inventory.transaction do
      resp[:from] = TradeService.trade_items(
        params[:idSurvivorFrom],
        params[:inventory_offer],
        params[:inventory_request]
      )
      resp[:to] = TradeService.trade_items(
        params[:idSurvivorTo],
        params[:inventory_request],
        params[:inventory_offer]
      )
    end
    render json: resp, status: :ok
  end

  def trade_params
    params.require(:trade).permit(
      :inventory_offer,
      :inventory_request
    )
  end
end
