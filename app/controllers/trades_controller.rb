class TradesController < ApplicationController
  include Errors

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
