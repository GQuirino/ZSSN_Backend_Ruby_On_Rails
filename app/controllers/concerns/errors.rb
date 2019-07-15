module Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      source = { survivor: e.id }
      render_error(:NOT_FOUND, 'Survivor not found', source)
    end

    rescue_from ActionController::ParameterMissing do |e|
      source = e
      render_error(:MISSING_DATA, 'Missing Data', source)
    end

    rescue_from ActiveModel::UnknownAttributeError do |e|
      source =  e.try(:attribute) || e
      render_error(:INTERNAL, 'nternal error', source)
    end

    rescue_from InternalError do |e|
      render_error(:INTERNAL, 'internal error', e)
    end
  end

  def render_survivor_infected(e)
    source = { survivor: e.id }
    render_error(:SURVIVOR_INFECTED, 'Survivor is infected', source)
  end

  def render_trade_invalid(e)
    source = { reason: e.reason }
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
