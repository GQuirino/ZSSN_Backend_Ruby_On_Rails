module Errors
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
    error[:source] = source.deep_stringify_keys
    error
  end
end
