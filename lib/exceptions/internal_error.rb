class InternalError < StandardError
  attr_accessor :reason
  def initialize(reason)
    @reason = reason
  end
end