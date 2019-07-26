class SurvivorInfectedError < StandardError
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end
