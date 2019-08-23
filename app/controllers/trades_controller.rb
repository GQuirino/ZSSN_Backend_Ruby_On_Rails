class TradesController < ApplicationController
  before_action :set_survivors, only: :update

  rescue_from ActiveRecord::RecordNotFound do |exception|
    error = Errors.resource_not_found(exception)
    render json: error, status: error[:status_code]
  end

  def update
    offer = {
      survivor: @survivor_offer,
      resources: offer_params[:inventory]
    }

    request = {
      survivor: @survivor_request,
      resources: requester_params[:inventory]
    }

    resp = TradeService.trade(offer, request)

    render json: resp, status: resp[:status_code] || :ok
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
