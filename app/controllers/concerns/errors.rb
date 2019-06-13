module Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      source = { survivor: e.id }
      new_error(:NOT_FOUND, 'Survivor not found', source)
    end

    rescue_from SurvivorInfectedError do |e|
      source = { survivor: e.id }
      new_error(:SURVIVOR_INFECTED, 'Survivor is infected', source)
    end

    rescue_from TradeInvalid do |e|
      source = { reason: e.reason }
      new_error(:INVALID_TRADE, 'Invalid Trade', source)
    end
  end

  class SurvivorInfectedError < StandardError
    attr_accessor :id
    def initialize(id)
      @id = id
    end
  end

  class TradeInvalid < StandardError
    attr_accessor :reason
    def initialize(reason)
      @reason = reason
    end
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
