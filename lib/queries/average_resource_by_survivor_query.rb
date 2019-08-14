module AverageResourceBySurvivorQuery
  def avg_resource(resource)
    resources_from_all_non_infected
      .where(resource_type: resource)
      .average(:resource_amount)
  end

  module_function :avg_resource

  def self.resources_from_all_non_infected
    Inventory.select(:resource_type, :resource_amount)
      .joins(:survivor)
      .merge(Survivor.non_infected)
  end
end
