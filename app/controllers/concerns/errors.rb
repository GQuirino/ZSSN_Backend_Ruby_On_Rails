module Errors
  def self.render_missing_data(exception)
    error = ERRORS[:MISSING_DATA]
    error[:source] = exception
    error
  end

  def self.render_resource_not_found(exception)
    error = ERRORS[:NOT_FOUND]
    error[:source] = exception
    error
  end

  def self.render_survivor_infected(id)
    error = ERRORS[:SURVIVOR_INFECTED]
    error[:source] = { survivor: id }
    error
  end

  def self.render_trade_invalid(exception)
    error = ERRORS[:INVALID_TRADE]
    error[:source] = { reason: exception }
    error
  end

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
    MISSING_DATA: {
      status_code: 422,
      details: 'Missing Data',
      title: 'MISSING DATA'
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
