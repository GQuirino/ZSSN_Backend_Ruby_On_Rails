module Errors
  def resource_not_found(exception)
    error = ERRORS[:NOT_FOUND]
    error[:source] = exception
    error
  end

  def survivor_infected(id)
    error = ERRORS[:SURVIVOR_INFECTED]
    error[:source] = { survivor: id }
    error
  end

  def trade_invalid(exception)
    error = ERRORS[:INVALID_TRADE]
    error[:source] = { reason: exception }
    error
  end

  module_function :resource_not_found, :survivor_infected, :trade_invalid

  ERRORS = {
    NOT_FOUND: {
      status_code: 404,
      details: 'Resource not found',
      title: 'NOT FOUND'
    },
    INTERNAL: {
      status_code: 500,
      title: 'INTERNAL ERROR'
    },
    INVALID_TRADE: {
      status_code: 403,
      details: 'Invalid Trade',
      title: 'INVALID TRADE'
    },
    SURVIVOR_INFECTED: {
      status_code: 400,
      details: 'Survivor is infected',
      title: 'SURVIVOR INFECTED'
    }
  }.freeze
end
