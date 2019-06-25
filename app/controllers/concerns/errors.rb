require './lib/exceptions/survivor_infected_error'
module Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      source = { survivor: e.id }
      new_error(:NOT_FOUND, 'Survivor not found', source)
    end

    rescue_from ActionController::ParameterMissing do |e|
      source = e
      new_error(:MISSING_DATA, 'Missing Data', source)
    end

    rescue_from ActiveModel::UnknownAttributeError do |e|
      source = e.attribute ? e.attribute : e
      new_error(:INTERNAL, 'internal Error', source)
    end
  end

  def raise_survivor_infected(e)
    source = { survivor: e.id }
    new_error(:SURVIVOR_INFECTED, 'Survivor is infected', source)
  end

  def raise_trade_invalid(e)
    source = { reason: e.reason }
    new_error(:INVALID_TRADE, 'Invalid Trade', source)
  end

  private

  ERRORS = {
    NOT_FOUND: {
      status_code: 404,
      title: 'NOT FOUND'
    },
    INTERNAL: {
      status_code: 500,
      title: 'INTERNAL ERROR'
    },
    MISSING_DATA: {
      status_code: 422,
      title: 'MISSING DATA'
    },
    INVALID_TRADE: {
      status_code: 403,
      title: 'INVALID TRADE'
    },
    SURVIVOR_INFECTED: {
      status_code: 400,
      title: 'SURVIVOR INFECTED'
    }
  }.freeze

  def new_error(code, details, source = {})
    error = ERRORS[code || :INTERNAL]
    error[:details] = details
    error[:source] = source
    render json: error, status: error[:status_code]
  end
end
