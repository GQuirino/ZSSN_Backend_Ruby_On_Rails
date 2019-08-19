module SurvivorService
  def increment_infection(survivor)
    survivor.flag_as_infected += 1
  end

  module_function :increment_infection
end
