module Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ActionController::ParameterMissing do |e|
      source = e
      render_error(:MISSING_DATA, 'Missing Data', source)
    end
  end

  def render_resource_not_found(exception)
    render_error(:NOT_FOUND, 'Resource not found', exception)
  end

  def render_survivor_infected(exception)
    source = { survivor: exception.id }
    render_error(:SURVIVOR_INFECTED, 'Survivor is infected', source)
  end

  def render_trade_invalid(exception)
    source = { reason: exception.reason }
    render_error(:INVALID_TRADE, 'Invalid Trade', source)
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

  def render_error(code, details, source = {})
    error = ERRORS[code || :INTERNAL]
    error[:details] = details
    error[:source] = source
    render json: error, status: error[:status_code]
  end
end
