module Queries
  class AverageResourceBySurvivor
    class << self
      def avg_resource(resource)
        resources_from_all_non_infected
          .where(resource_type: resource)
          .average(:resource_amount)
      end

      private

      def resources_from_all_non_infected
        Inventory.select(:resource_type, :resource_amount)
          .joins(:survivor)
          .merge(Survivor.non_infected)
      end
    end
  end
end
