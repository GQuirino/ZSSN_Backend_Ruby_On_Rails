module Errors
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      source = { survivor: e.id }
      new_error(:NOT_FOUND, 'Survivor not found', source)
    end

    rescue_from SurvivorInfectedError do |e|
      source = { survivor: e.id }
      new_error(:SURVIVOR_INFECTED, 'Survivor already infected', source)
    end
  end

  class SurvivorInfectedError < StandardError
    attr_accessor :id
    def initialize(id)
      @id = id
    end
  end

  private

  ERRORS = {
    NOT_FOUND: {
      status: 404,
      title: 'NOT FOUND'
    },
    INTERNAL: {
      status: 500,
      title: 'INTERNAL ERROR'
    },
    MISSING_DATA: {
      statusCode: 422,
      title: 'MISSING DATA'
    },
    INVALID_TRADE: {
      statusCode: 403,
      title: 'INVALID TRADE'
    },
    SURVIVOR_INFECTED: {
      statusCode: 400,
      title: 'SURVIVOR INFECTED'
    }
  }.freeze

  def new_error(code, details, source = {})
    error = ERRORS[code || :INTERNAL]
    error[:details] = details
    error[:source] = source
    render json: error, status: error[:status]
  end
end
