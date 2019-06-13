class TradesController < ApplicationController
  include Errors

  def update
    # check transactions
    @survivor_from = Survivor.find(params[:idSurvivorFrom])
    @survivor_to = Survivor.find(params[:idSurvivorTo])
    raise SurvivorInfectedError, params[:idSurvivorFrom] if @survivor_from.infected?
    raise SurvivorInfectedError, params[:idSurvivorTo] if @survivor_to.infected?

    resp = TradeService.trade_items(
      @survivor_from,
      @survivor_to,
      params[:inventory_offer],
      params[:inventory_request]
    )

    render json: resp, status: :ok
  end

  def trade_params
    params.require(:trade).permit(
      :inventory_offer,
      :inventory_request
    )
  end
end
