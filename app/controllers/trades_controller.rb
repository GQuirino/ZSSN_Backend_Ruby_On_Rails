class TradesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = Errors.render_resource_not_found(exception)
    render json: error, status: error[:status_code]
  end

  def update
    resp = TradeService.trade(offer_params, requester_params)

    render json: resp, status: resp[:status_code] || :ok
  end

  private

  def find_survivor(id)
    Survivor.find(id)
  end

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
