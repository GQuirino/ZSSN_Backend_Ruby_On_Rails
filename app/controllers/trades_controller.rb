class TradesController < ApplicationController
  before_action :set_survivors, only: :update

  def update
    offer = {
      survivor: @survivor_offer,
      resources: offer_params[:inventory]
    }

    request = {
      survivor: @survivor_request,
      resources: requester_params[:inventory]
    }

    exchange = Trade::Exchange.new(offer, request)

    return render json: exchange.errors, status: 403 if exchange.errors.validation_error?

    exchange.trade

    render json: exchange, status: :ok
  end

  private

  def set_survivors
    @survivor_offer = Survivor.find(offer_params[:id_survivor])
    @survivor_request = Survivor.find(requester_params[:id_survivor])
  end

  def offer_params
    {
      id_survivor_from: params.require(:id_survivor_from),
      id_survivor_to: params.require(:id_survivor_to),
      inventory_offer: params.require(:inventory_offer),
      inventory_request: params.require(:inventory_request)
    }
  end
end
