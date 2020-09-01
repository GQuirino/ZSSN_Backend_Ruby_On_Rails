class TradesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = Errors.resource_not_found(exception)
    render json: error, status: error[:status_code]
  end

  def update
    offer_params = { id_survivor: trade_params[:id_survivor_from],
                     inventory: trade_params[:inventory_offer].permit! }
    requester_params = { id_survivor: trade_params[:id_survivor_to],
                         inventory: trade_params[:inventory_request].permit! }

    resp = TradeService.trade(offer_params, requester_params)

    render json: resp, status: resp[:status_code] || :ok
  end

  private

  def trade_params
    {
      id_survivor_from: params.require(:id_survivor_from),
      id_survivor_to: params.require(:id_survivor_to),
      inventory_offer: params.require(:inventory_offer),
      inventory_request: params.require(:inventory_request)
    }
  end
end
